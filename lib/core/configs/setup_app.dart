import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sumbalist/controllers/login_controller.dart';

import 'package:sumbalist/core/di/dependecy_injection.dart';
import 'package:sumbalist/core/error/errorLog.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:sumbalist/utils/theme/theme.dart';
import 'package:sumbalist/utils/utils.dart';
import '../../firebase_options.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DependencyInjection().setup();
  await AppTheme.loadThemeMode();
  await AppCurrencyFormat.init();
  await Utils.checkIsFirstTimeRun();
  await loadVersion();

  //Create Temp User if the App Run first Time

  if (Utils.isFirstTimeRun) {
    await LoginController.createTempUser();
  } else {
    await LoginController.checkUserAuthenticated();
  }
}

Future<void> loadVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();

  devLog(
      "APP VERSION:: ${packageInfo.version} (Build ${packageInfo.buildNumber})");
}
