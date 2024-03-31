import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/controllers/login_controller.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:sumbalist/utils/theme/theme.dart';
import 'package:sumbalist/utils/utils.dart';
import '../controllers/shopping_list_controller.dart';
import '../core/database.dart';
import '../firebase_options.dart';
import '../repository/shopping_list_item_repository.dart';
import '../repository/shopping_list_repository.dart';

Future<void> initConfig() async {
  var locator = GetIt.instance;
  AppDatabase database = AppDatabase(urlDatabase: "sumbalist.db");

  var shoppingListRepository = ShoppingListRepository(database);
  var shoppingListItemRepository = ShoppingListItemRepository(database);
  var shoplistController = ShoppingListController(
      shoppingListRepository, shoppingListItemRepository);

  await AppTheme.loadThemeMode();

  await AppCurrencyFormat.init();
  locator.registerSingleton(shoplistController);
  Get.put(shoplistController);

  await LoginController.checkUserAuthenticated();
  await Utils.checkIsFirstTimeRun();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
