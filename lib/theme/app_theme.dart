import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Color(0xff007B80),
      secondary: Colors.blueAccent,
    ),
  );

  static ThemeData dark = ThemeData.dark();
}
