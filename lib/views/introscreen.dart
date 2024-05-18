import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduction'),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              buildPage('Page 1', 'Explanation 1'),
              buildPage('Page 2', 'Explanation 2'),
              buildPage('Page 3', 'Explanation 3'),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
