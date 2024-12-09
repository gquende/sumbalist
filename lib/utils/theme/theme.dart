import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumbalist/utils/theme/icon_theme.dart';
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
  static var isDarkMode = false.obs;

  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: PRIMARYCOLOR,
    primaryColorDark: SECONDARYCOLOR,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    textTheme: TTextTheme.lightTextTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckButtonTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButton,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    buttonTheme: TButtonTheme.lightButtonTheme,
    textButtonTheme: TTextButtonTheme.lightTextButtonTheme,
    iconTheme: TIconTheme.lightAppBarTheme,
    colorScheme: ColorScheme.dark(
        primary: PRIMARYCOLOR,
        background: Colors.white,
        secondary: SECONDARYCOLOR,
        primaryContainer: Colors.white,
        secondaryContainer: Color(0xffe5e5e5)),
  );

  static ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xff181719),
      primaryColor: PRIMARYCOLOR,
      primaryColorDark: SECONDARYCOLOR,
      colorScheme: const ColorScheme.dark(
          primary: PRIMARYCOLOR,
          background: Color(0xff181719),
          secondary: Color(0xff1F222B),
          primaryContainer: Color(0xff232224),
          secondaryContainer: Color(0xff2C2C2D)),
      appBarTheme: const AppBarTheme(
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
          color: Colors.transparent,
          titleTextStyle: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      textTheme: TTextTheme.darkTextTheme,
      checkboxTheme: TCheckBoxTheme.darkCheckButtonTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButton,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
      buttonTheme: TButtonTheme.darkButtonTheme,
      textButtonTheme: TTextButtonTheme.darkTextButtonTheme,
      iconTheme: TIconTheme.darkAppBarTheme);

  static setDarkMode(bool value) async {
    isDarkMode.value = value;
    var shared = await SharedPreferences.getInstance();
    shared.setBool("themeMode", value);
  }

  static Future<bool> loadThemeMode() async {
    var shared = await SharedPreferences.getInstance();
    isDarkMode.value = shared.getBool("themeMode") ?? false;

    return isDarkMode.value;
  }
}
