import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

class Utils {
  static void showSnackBar(
      String title, String message, Widget icon, Color color) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: color.withOpacity(.4),
      title: title,
      isDismissible: true,
      duration: const Duration(milliseconds: 3000),
      icon: icon,
      message: message,
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 20,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      snackStyle: SnackStyle.GROUNDED,
      barBlur: 30,
    ));
  }
}