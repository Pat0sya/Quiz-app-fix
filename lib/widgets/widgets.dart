import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: const TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
        TextSpan(
            text: 'Maker',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
      ],
    ),
  );
}

Widget blueButton(BuildContext context, String label) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(30),
    ),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
