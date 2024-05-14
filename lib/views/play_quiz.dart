import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/question_model.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/widgets/quiz_play_widget.dart';
import 'package:flutterapp/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz(this.quizId);

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  late DatabaseService databaseService = new DatabaseService();
  QuerySnapshot? questionSnapshot;

  QuestionModel getQuestionModelFromDataSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    Map<String, dynamic>? data =
        questionSnapshot.data() as Map<String, dynamic>?;
    questionModel.question = data?["question"];
    List<String> options = [
      data?["option1"],
      data?["option2"],
      data?["option3"],
      data?["option4"],
    ];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = data?["option1"];
    questionModel.answered = false;
    return questionModel;
  }

  @override
  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    if (widget.quizId.isNotEmpty) {
      databaseService.getQuizData(widget.quizId).then((value) {
        setState(() {
          questionSnapshot = value;
          _notAttempted = 0;
          _correct = 0;
          _incorrect = 0;
          total = questionSnapshot?.docs.length ?? 0;
          print("$total this is total");
        });
      });
    } else {
      // Handle the error appropriately, e.g., show a message to the user.
      print("Quiz ID is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black54,
        ),
        title: appBar(context),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        child: Column(
          children: [
            questionSnapshot == null
                ? Container(child: Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: questionSnapshot?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        return QuizPlayTile(
                          questionModel: getQuestionModelFromDataSnapshot(
                              questionSnapshot!.docs[index]),
                          index: index,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({required this.questionModel, required this.index});

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.questionModel.question ?? ""),
          SizedBox(height: 4),
          OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option1,
            option: "A",
            optionSelected: optionSelected,
          ),
          SizedBox(height: 4),
          OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option2,
            option: "B",
            optionSelected: optionSelected,
          ),
          SizedBox(height: 4),
          OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option3,
            option: "C",
            optionSelected: optionSelected,
          ),
          SizedBox(height: 4),
          OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option4,
            option: "D",
            optionSelected: optionSelected,
          ),
        ],
      ),
    );
  }
}
