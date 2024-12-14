import 'package:flutter/material.dart';

class AppStyles {
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle hintTextStyle = TextStyle(
    color: Colors.white,
  );

  static const TextStyle inputTextStyle = TextStyle(
    color: Colors.white,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
  );

  static const TextStyle linkTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static const TextStyle footerTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  static const InputDecoration golosovanieDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.black,
    hintStyle: hintTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  static const InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.black,
    hintStyle: hintTextStyle,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );

  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    padding: EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  static const BoxDecoration backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF96D7B4), // 0%
        Color(0xFF37BE76), // 28%
        Color(0xFF195158), // 100%
      ],
      stops: [0.0, 0.28, 1.0],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static const sectionTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const listTileTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );

}
