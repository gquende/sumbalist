import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/pages/home/home.dart';
import 'package:sumbalist/pages/login.dart';
import 'package:sumbalist/pages/onboarding.dart';
import 'package:sumbalist/repository/shopping_list_item_repository.dart';
import 'package:sumbalist/repository/shopping_list_repository.dart';
import 'package:sumbalist/utils/theme/theme.dart';
import 'package:sumbalist/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'controllers/currency_controller.dart';
import 'controllers/shopping_list_controller.dart';
import 'core/configs/app_locale.dart';
import 'core/di/dependecy_injection.dart';
import 'models/users.dart';

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
        ChangeNotifierProvider(create: (_) => CurrencyController()),
      ],
      child: ListenableBuilder(
          listenable: Listenable.merge([DI.get<AppLocale>()]),
          builder: (_, __) {
            return Obx(() => GetMaterialApp(
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  debugShowCheckedModeBanner: false,
                  locale: DI.get<AppLocale>().locale.value,
                  theme: AppTheme.isDarkMode.value
                      ? AppTheme.darkMode
                      : AppTheme.light,
                  darkTheme: AppTheme.darkMode,
                  home: Utils.isFirstTimeRun
                      ? const OnBoarding()
                      : User.logged != null
                          ? Home()
                          : const Login(),
                ));
          }),
    );
  }
}
