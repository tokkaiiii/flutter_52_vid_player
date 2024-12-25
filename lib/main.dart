import 'package:flutter/material.dart';
import 'package:vid_52_player/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: 'sunflower',
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: Colors.black, fontSize: 32.0, fontFamily: 'parisienne'),
        displayMedium: TextStyle(
          color: Colors.pink[100],
          fontSize: 50.0,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: Colors.pink[100],
          fontSize: 30.0,
        ),
        bodyMedium: TextStyle(
          color: Colors.pink[100],
          fontSize: 20.0,
        ),
      ),
    ),
    home: HomeScreen(),
  ));
}
