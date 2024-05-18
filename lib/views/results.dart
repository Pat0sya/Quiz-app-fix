import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/widgets/widgets.dart'; // Assuming blueButton is defined here
import 'package:percent_indicator/percent_indicator.dart'; // Add this import

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  const Results(
      {super.key,
      required this.correct,
      required this.incorrect,
      required this.total});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _getResultAnimation() {
    double percentage = widget.correct / widget.total * 100;
    if (percentage > 80) {
      return AnimatedEmoji(
        AnimatedEmojis.grin,
        size: 100,
      );
    } else if (percentage >= 50) {
      return AnimatedEmoji(
        AnimatedEmojis.smile,
        size: 100,
      );
    } else {
      return AnimatedEmoji(
        AnimatedEmojis.sad,
        size: 100,
      );
    }
  }

  String _getResultMessage() {
    double percentage = widget.correct / widget.total * 100;
    if (percentage > 80) {
      return "Well done!";
    } else if (percentage >= 50) {
      return "Good Job!";
    } else {
      return "Better Luck next time!";
    }
  }

  LinearGradient _getBackgroundGradient() {
    double percentage = widget.correct / widget.total * 100;
    if (percentage > 80) {
      return const LinearGradient(
        colors: [Colors.green, Colors.lightGreenAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (percentage >= 50) {
      return const LinearGradient(
        colors: [Colors.blueAccent, Colors.lightBlueAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Colors.redAccent, Colors.deepOrangeAccent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.correct / widget.total;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getBackgroundGradient(),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getResultMessage(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: percentage,
                  center: Text(
                    "${(percentage * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  progressColor: Colors.white,
                  backgroundColor: const Color.fromARGB(59, 255, 255, 255),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "You answered ${widget.correct} answers correctly and ${widget.incorrect} answers incorrectly",
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: _getResultAnimation(),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: blueButton(
                    context: context,
                    label: "Home",
                    buttonWidth: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
