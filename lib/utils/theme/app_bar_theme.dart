


import 'package:flutter/material.dart';

class TAppBarTheme{

  TAppBarTheme._();
  static const lightAppBarTheme= AppBarTheme(
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color:  Colors.black, size: 24),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.black)

  );


  static const darkAppBarTheme= AppBarTheme(
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color:  Colors.black, size: 24),
      actionsIconTheme: IconThemeData(color: Colors.black, size: 24),
      titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600, color: Colors.black)

  );


}