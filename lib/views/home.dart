import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/create_quiz.dart';
import 'package:flutterapp/views/play_quiz.dart';
import 'package:flutterapp/widgets/widgets.dart';
import 'package:flutterapp/views/signin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? quizStream;
  DatabaseService databaseService = DatabaseService();

  Widget quizList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var docData = snapshot.data!.docs[index].data();
              return index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: QuizTile(
                        imgUrl: docData?["quizImgUrl"] ?? "",
                        title: docData?['quizTitle'] ?? "",
                        desc: docData?['quizDesc'] ?? "",
                        quizid: docData?["quizId"] ?? "",
                        refreshCallback: () {
                          setState(() {}); // Refresh the list
                        },
                      ),
                    )
                  : QuizTile(
                      imgUrl: docData?["quizImgUrl"] ?? "",
                      title: docData?['quizTitle'] ?? "",
                      desc: docData?['quizDesc'] ?? "",
                      quizid: docData?["quizId"] ?? "",
                      refreshCallback: () {
                        setState(() {}); // Refresh the list
                      },
                    );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    databaseService.getQuizezData().then((value) {
      setState(() {
        quizStream = value;
      });
    });
  }

  void signOut() async {
    AuthService authService = AuthService();
    await authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.blue,
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: quizList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuiz()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;
  final VoidCallback refreshCallback;
  final DatabaseService databaseService = DatabaseService();

  QuizTile({
    super.key,
    required this.imgUrl,
    required this.title,
    required this.desc,
    required this.quizid,
    required this.refreshCallback,
  });

  void _deleteQuiz(BuildContext context) async {
    await databaseService.deleteQuiz(quizid);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Quiz deleted successfully'),
    ));
    refreshCallback();
  }

  void _showDeleteConfirmationDialog(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email == 'admin@gmail.com') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Quiz'),
            content: const Text('Are you sure you want to delete this quiz?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteQuiz(context);
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You do not have permission to delete this quiz'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlayQuiz(quizid)),
        );
      },
      onLongPress: () {
        _showDeleteConfirmationDialog(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                height: 150,
                fit: BoxFit.cover,
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
