import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/core/configs/app_locale.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../repository/shopping_list_item_repository.dart';
import '../../repository/shopping_list_repository.dart';
import '../configs/config.dart';
import '../database.dart';

final class DependencyInjection {
  static DependencyInjection? _instance;

  DependencyInjection._();

  factory DependencyInjection() => _instance ??= DependencyInjection._();

  Future<void> setup() async {
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
    locator.registerSingleton(AppConfig());
    var locale = AppLocale(Locale("pt"));
    await locale.load();
    locator.registerSingleton(locale);
    locator.registerSingleton(shoplistController);
    Get.put(shoplistController);
  }
}

abstract class DI {
  static T get<T extends Object>() => GetIt.I.get<T>();
}
