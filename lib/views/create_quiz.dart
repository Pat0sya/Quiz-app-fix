import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/addquistion.dart';
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
  DatabaseServie databaseServie = new DatabaseServie();
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
            MaterialPageRoute(builder: (context) => AddQuestion()),
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
        iconTheme: IconThemeData(color: Colors.black87),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Image URL" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Image Url",
                        ),
                        onChanged: (val) {
                          quizImageUrl = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Title" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Title",
                        ),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Description" : null,
                        decoration: InputDecoration(
                          hintText: "Enter Quiz Description",
                        ),
                        onChanged: (val) {
                          quizDescripstion = val;
                        },
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            CreateQuizOnLine();
                          },
                          child: blueButton(context, 'Create Quiz')),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  )),
            ),
    );
  }
}
