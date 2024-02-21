import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../controllers/shopping_list_controller.dart';
import '../core/database.dart';
import '../repository/shopping_list_item_repository.dart';
import '../repository/shopping_list_repository.dart';

Future<void> initConfig() async {
  var locator = GetIt.instance;
  AppDatabase database = AppDatabase(urlDatabase: "sumbalist.db");

  var shoppingListRepository = ShoppingListRepository(database);
  var shoppingListItemRepository = ShoppingListItemRepository(database);
  var shoplistController = ShoppingListController(
      shoppingListRepository, shoppingListItemRepository);
  locator.registerSingleton(shoplistController);
  Get.put(ShoppingListController(
      shoppingListRepository, shoppingListItemRepository));
}
