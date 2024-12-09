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
  AppDatabase database = AppDatabase();
  await database.open("sumbalist.db");

  locator.registerSingleton(database);

  var shoppingListRepository = ShoppingListRepository(database);
  var shoppingListItemRepository = ShoppingListItemRepository(database);
  var shoplistController = ShoppingListController(
      shoppingListRepository, shoppingListItemRepository);

  // await shoplistController.getAllShoppingList();
  locator.registerSingleton(shoppingListRepository);
  locator.registerSingleton(shoppingListItemRepository);

  await AppTheme.loadThemeMode();

  await AppCurrencyFormat.init();
  locator.registerSingleton(shoplistController);
  Get.put(shoplistController);

  await Utils.checkIsFirstTimeRun();

  //Create Temp User if the App Run first Time
  if (Utils.isFirstTimeRun) {
    await LoginController.createTempUser();
  } else {
    await LoginController.checkUserAuthenticated();
  }

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
