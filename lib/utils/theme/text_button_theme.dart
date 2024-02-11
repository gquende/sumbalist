import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class TTextButtonTheme {
  static final lightTextButtonTheme = TextButtonThemeData(
      style: TextButton.styleFrom(
          backgroundColor: PRIMARYCOLOR, foregroundColor: Colors.white));
  static final darkTextButtonTheme =
      TextButtonThemeData(style: TextButton.styleFrom());
}
