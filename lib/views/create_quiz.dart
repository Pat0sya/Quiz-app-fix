import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/addquestion.dart';
import 'package:flutterapp/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizImageUrl, quizTitle, quizDescripstion, quizId;
  DatabaseServie databaseServie = DatabaseServie();
  bool _isLoading = false;

  CreateQuizOnLine() async {
    if (_formKey.currentState!.validate()) {
      quizId = randomAlphaNumeric(16);
      setState(() {
        _isLoading = true;
      });

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescripstion
      };

      await databaseServie.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Image URL" : null,
                        decoration: const InputDecoration(
                          hintText: "Quiz Image Url",
                        ),
                        onChanged: (val) {
                          quizImageUrl = val;
                        },
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Title" : null,
                        decoration: const InputDecoration(
                          hintText: "Quiz Title",
                        ),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Description" : null,
                        decoration: const InputDecoration(
                          hintText: "Enter Quiz Description",
                        ),
                        onChanged: (val) {
                          quizDescripstion = val;
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          CreateQuizOnLine();
                        },
                        //child: blueButton(context: context, label: "Create Quiz")
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
            ),
    );
  }
}
