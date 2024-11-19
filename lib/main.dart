import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/pages/home/home.dart';
import 'package:sumbalist/pages/login.dart';
import 'package:sumbalist/pages/onboarding.dart';
import 'package:sumbalist/repository/shopping_list_item_repository.dart';
import 'package:sumbalist/repository/shopping_list_repository.dart';
import 'package:sumbalist/utils/utils.dart';

import 'configs/config.dart';
import 'controllers/shopping_list_controller.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ShoppingListController(
                GetIt.instance.get<ShoppingListRepository>(),
                GetIt.instance.get<ShoppingListItemRepository>())),
      ],
      child: Obx(() => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                AppTheme.isDarkMode.value ? AppTheme.darkMode : AppTheme.light,
            darkTheme: AppTheme.darkMode,
            home: Utils.isFirstTimeRun
                ? const OnBoarding()
                : User.logged != null
                    ? Home()
                    : const Login(),
          )),
    );
  }
}
