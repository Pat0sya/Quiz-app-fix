import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
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
    );
  }
}
