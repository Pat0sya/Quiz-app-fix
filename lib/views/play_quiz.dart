import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/models/question_model.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/results.dart';
import 'package:flutterapp/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  const PlayQuiz(this.quizId, {super.key});

  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  late DatabaseService databaseService = DatabaseService();
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
        leading: const BackButton(
          color: Colors.black54,
        ),
        title: appBar(context),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            questionSnapshot == null
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Results(
                correct: _correct,
                incorrect: _incorrect,
                total: total,
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  const QuizPlayTile(
      {super.key, required this.questionModel, required this.index});

  @override
  State<QuizPlayTile> createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1}: ${widget.questionModel.question ?? ""}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < 4; i++)
            GestureDetector(
              onTap: () {
                if (!widget.questionModel.answered) {
                  bool isCorrect = false;
                  switch (i) {
                    case 0:
                      isCorrect = widget.questionModel.option1 ==
                          widget.questionModel.correctOption;
                      optionSelected = widget.questionModel.option1;
                      break;
                    case 1:
                      isCorrect = widget.questionModel.option2 ==
                          widget.questionModel.correctOption;
                      optionSelected = widget.questionModel.option2;
                      break;
                    case 2:
                      isCorrect = widget.questionModel.option3 ==
                          widget.questionModel.correctOption;
                      optionSelected = widget.questionModel.option3;
                      break;
                    case 3:
                      isCorrect = widget.questionModel.option4 ==
                          widget.questionModel.correctOption;
                      optionSelected = widget.questionModel.option4;
                      break;
                  }

                  setState(() {
                    widget.questionModel.answered = true;
                    if (isCorrect) {
                      _correct++;
                    } else {
                      _incorrect++;
                    }
                    _notAttempted--;
                  });
                }
              },
              child: OptionTile(
                correctAnswer: widget.questionModel.correctOption,
                description: [
                  widget.questionModel.option1,
                  widget.questionModel.option2,
                  widget.questionModel.option3,
                  widget.questionModel.option4
                ][i],
                option: String.fromCharCode(65 + i),
                optionSelected: optionSelected,
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String correctAnswer;
  final String description;
  final String option;
  final String optionSelected;

  const OptionTile(
      {super.key,
      required this.correctAnswer,
      required this.description,
      required this.option,
      required this.optionSelected});

  @override
  Widget build(BuildContext context) {
    bool isSelected = optionSelected == description;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.grey.shade300,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blueAccent.withOpacity(0.2) : Colors.white,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isSelected ? Colors.blueAccent : Colors.grey.shade300,
          child: Text(
            option,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          description,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
