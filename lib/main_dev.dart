import 'package:flutter/material.dart';
import 'app.dart';
import 'core/configs/setup_app.dart';

void main() async {
  await setupApp();

  runApp(App(
    isDarkMode: false,
  ));
}
