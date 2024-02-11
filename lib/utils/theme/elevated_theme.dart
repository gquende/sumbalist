

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class TElevatedButtonTheme {

  static final lightElevatedButton= ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: PRIMARYCOLOR,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: BorderSide(color: PRIMARYCOLOR,),
          padding: EdgeInsets.symmetric(vertical: 18),
          textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)))
  );


  static final darkElevatedButton= ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: PRIMARYCOLOR,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey,
          disabledForegroundColor: Colors.grey,
          side: BorderSide(color: PRIMARYCOLOR),
          padding: EdgeInsets.symmetric(vertical: 18),
          textStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)))
  );

}


