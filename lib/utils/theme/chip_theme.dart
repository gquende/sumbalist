import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TChipTheme {
  static final lightChipTheme = ChipThemeData(
      disabledColor: Colors.grey.withOpacity(0.4),
      labelStyle: const TextStyle(color: Colors.black),
      selectedColor: PRIMARYCOLOR,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: Colors.white);
  static final darkChipTheme = ChipThemeData(
      disabledColor: Colors.grey,
      labelStyle: const TextStyle(color: Colors.white),
      selectedColor: PRIMARYCOLOR,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: Colors.white);
}
