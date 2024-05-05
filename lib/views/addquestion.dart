import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  AddQuestion(this.quizId);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  DatabaseService databaseServie = new DatabaseService();

  bool _isLoading = false;

  uploadQuestionData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      databaseServie.addQuestionData(questionMap, widget.quizId).then((value) {
        setState(() {
          _isLoading = false;
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      decoration: const InputDecoration(
                        hintText: "Question",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter First Option" : null,
                      decoration: const InputDecoration(
                        hintText: "First Option (Correct Answer)",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Second Option" : null,
                      decoration: const InputDecoration(
                        hintText: "Second Option",
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Third Option" : null,
                      decoration: const InputDecoration(
                        hintText: "Third Option",
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter FSourth Option" : null,
                      decoration: const InputDecoration(
                        hintText: "Fourth Option",
                      ),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: blueButton(
                              context: context,
                              label: "Submit",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            uploadQuestionData();
                          },
                          child: blueButton(
                              context: context,
                              label: "Add Question",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
