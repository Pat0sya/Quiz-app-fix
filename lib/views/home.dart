import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/create_quiz.dart';
import 'package:flutterapp/widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream quizStream;
  DatabaseService databaseSevice = new DatabaseService();

  Widget quizList() {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or any loading indicator
          }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Text("No data available");
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final quizData =
                  snapshot.data.docs[index].data() as Map<String, dynamic>;
              final imgUrl = quizData["quizImgUrl"];
              final desc = quizData["quizDesc"];
              final title = quizData["quizTitle"];
              return QuizTile(
                imgUrl: imgUrl ?? "",
                desc: desc ?? "",
                title: title ?? "",
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    databaseSevice.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
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
  QuizTile({required this.imgUrl, required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.network(imgUrl),
          Container(
            child: Column(
              children: [Text(title), Text(desc)],
            ),
          )
        ],
      ),
    );
  }
}
