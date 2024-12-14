import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sumbalist/controllers/login_controller.dart';
import 'package:sumbalist/core/di/dependecy_injection.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:sumbalist/utils/theme/theme.dart';
import 'package:sumbalist/utils/utils.dart';
import '../../firebase_options.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection().setup();
  await AppTheme.loadThemeMode();
  await AppCurrencyFormat.init();
  await Utils.checkIsFirstTimeRun();

  //Create Temp User if the App Run first Time
  if (Utils.isFirstTimeRun) {
    await LoginController.createTempUser();
  } else {
    await LoginController.checkUserAuthenticated();
  }

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
