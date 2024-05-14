import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/views/addquestion.dart';
import 'package:flutterapp/widgets/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  DatabaseService databaseService = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  late String quizImgUrl, quizTitle, quizDesc;

  bool isLoading = false;
  late String quizId;

  // Replace with your own Unsplash API key
  final String unsplashAPIKey = 'vg57DLRAgkfKS1dM87f75o_d8QOtxI6gD9GsZGmVOzg';

  Future<String> fetchRandomImageUrl() async {
    final response = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/random?client_id=$unsplashAPIKey'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['urls']['regular'];
    } else {
      throw Exception('Failed to load random image');
    }
  }

  Future<bool> validateImageUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  createQuiz() async {
    quizId = randomAlphaNumeric(16);

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      if (quizImgUrl.isEmpty || !(await validateImageUrl(quizImgUrl))) {
        quizImgUrl = await fetchRandomImageUrl();
      }

      Map<String, String> quizData = {
        "quizId": quizId,
        "quizImgUrl": quizImgUrl,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc
      };

      databaseService.addQuizData(quizData, quizId).then((value) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
      });
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
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Quiz Image Url (optional)",
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (val) {
                          quizImgUrl = val;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Title" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Title",
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (val) {
                          quizTitle = val;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter Quiz Description" : null,
                        decoration: InputDecoration(
                          hintText: "Quiz Description",
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (val) {
                          quizDesc = val;
                        },
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          createQuiz();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.blue, // Use solid color
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            "Create Quiz",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
