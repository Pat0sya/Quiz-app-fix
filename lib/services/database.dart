import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    if (quizId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(quizId)
          .set(quizData)
          .catchError((e) {
        print(e.toString());
      });
    } else {
      print("Quiz ID is empty");
    }
  }

  Future<void> addQuestionData(Map questionData, String quizId) async {
    if (quizId.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(quizId)
          .collection("QNA")
          .add(questionData.cast<String, dynamic>())
          .catchError((e) {
        print(e);
      });
    } else {
      print("Quiz ID is empty");
    }
  }

  getQuizezData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuizData(String quizId) async {
    if (quizId.isNotEmpty) {
      return await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(quizId)
          .collection("QNA")
          .get();
    } else {
      print("Quiz ID is empty");
      return null;
    }
  }
}
