import 'package:flutter/material.dart';
import 'package:sumbalist/utils/theme/text_button_theme.dart';
import 'package:sumbalist/utils/theme/text_theme.dart';
import 'package:sumbalist/utils/theme/textfield_theme.dart';

import '../constants/app_colors.dart';
import 'app_bar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'button_theme.dart';
import 'checkbox_theme.dart';
import 'elevated_theme.dart';

class AppTheme {
  var mode1 = const Color(0xff181719);
  var mode2 = const Color(0xff27242C);
  var mode3 = const Color(0xff3D3A41);
  var mode4 = const Color(0xff28272F);
  var mode5 = const Color(0xff151416);

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
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff181719),
      primaryColor: PRIMARYCOLOR,
      primaryColorDark: SECONDARYCOLOR,
      colorScheme: ColorScheme.dark(
          primary: PRIMARYCOLOR,
          background: Color(0xff181719),
          secondary: Color(0xff1F222B),
          primaryContainer: const Color(0xff27242C),
          secondaryContainer: Color(0xff151416)),
      appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
          color: Colors.transparent,
          titleTextStyle: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)));
}
