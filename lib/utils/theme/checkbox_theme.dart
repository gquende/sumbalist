import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TCheckBoxTheme {
  static final lightCheckButtonTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return Colors.white;
        else
          return Colors.black;
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return PRIMARYCOLOR;
        else
          return Colors.transparent;
      }));

  static final darkCheckButtonTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      checkColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return Colors.white;
        else
          return Colors.black;
      }),
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected))
          return PRIMARYCOLOR;
        else
          return Colors.transparent;
      }));
}
