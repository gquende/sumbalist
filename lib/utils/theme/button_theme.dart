import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class TButtonTheme {
  static final lightButtonTheme = ButtonThemeData(buttonColor: PRIMARYCOLOR);
  static final darkButtonTheme = BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: Colors.black,
      modalBackgroundColor: Colors.black,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
}
