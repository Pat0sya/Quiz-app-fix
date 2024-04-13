import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;

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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Question" : null,
                decoration: InputDecoration(
                  hintText: "Question",
                ),
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter First Option" : null,
                decoration: InputDecoration(
                  hintText: "First Option (Correct Answer)",
                ),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Second Option" : null,
                decoration: InputDecoration(
                  hintText: "Second Option",
                ),
                onChanged: (val) {
                  option2 = val;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Third Option" : null,
                decoration: InputDecoration(
                  hintText: "Third Option",
                ),
                onChanged: (val) {
                  option3 = val;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Enter Fourth Option" : null,
                decoration: InputDecoration(
                  hintText: "Fourth Option",
                ),
                onChanged: (val) {
                  option4 = val;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
