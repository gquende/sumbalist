import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sumbalist/utils/theme/text_button_theme.dart';
import 'package:sumbalist/utils/theme/text_theme.dart';
import 'package:sumbalist/utils/theme/textfield_theme.dart';
import '../../constants/app_colors.dart';
import 'app_bar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'button_theme.dart';
import 'checkbox_theme.dart';
import 'elevated_theme.dart';

class AppTheme {
  static ThemeData light = ThemeData(
      primaryColor: PRIMARYCOLOR,
      primaryColorDark: SECONDARYCOLOR,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      textTheme: TTextTheme.lightTextTheme,
      checkboxTheme: TCheckBoxTheme.lightCheckButtonTheme,
      bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButton,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
      buttonTheme: TButtonTheme.lightButtonTheme,
      textButtonTheme: TTextButtonTheme.lightTextButtonTheme);

  static ThemeData darkMode = ThemeData(
      appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
          color: Colors.transparent,
          titleTextStyle: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)));
}
