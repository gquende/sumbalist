import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/pages/home.dart';
import 'package:sumbalist/pages/login.dart';
import 'package:sumbalist/pages/onboarding.dart';
import 'package:sumbalist/utils/utils.dart';

import 'configs/config.dart';
import 'models/users.dart';
import 'utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initConfig();

  runApp(App(
    isDarkMode: false,
  ));
}

class App extends StatelessWidget {
  bool isDarkMode;
  App({required this.isDarkMode});

  //
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkMode : AppTheme.light,
      darkTheme: AppTheme.darkMode,
      home: Utils.isFirstTimeRun
          ? OnBoarding()
          : User.logged != null
              ? Home()
              : Login(),
    );
  }
}
