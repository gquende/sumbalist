import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';
import '../repository/shopping_list_item_repository.dart';
import '../repository/shopping_list_repository.dart';
import 'base_controller.dart';

class ShoppingListController extends BaseController {
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Rx<ShoppingList> shoppingList = ShoppingList(
          uuid: '',
          userUUID: '',
          categoryUUID: '',
          statusUUID: '',
          name: '',
          total: 0)
      .obs;

  int priority = 1;
  var isLoading = false.obs;

  var shoppinglist = <ShoppingList>[].obs;

  ShoppingListRepository repository;
  ShoppingListItemRepository itemRepository;

  ShoppingListController(this.repository, this.itemRepository);

  Future<bool> createShoppinglist(ShoppingList shoppingList) async {
    try {
      var item = await repository.create(shoppingList);
      await getShoppingList();
      print(item);
      return true;
    } catch (error) {
      debugPrint(error.toString());
    }

    return false;
  }

  Future<List<ShoppingList>> getShoppingList() async {
    try {
      isLoading.value = true;
      shoppinglist.value = await repository.getAllList();

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;

      debugPrint(
          "ShoppinglistController:: getShoppingList::ERROR : ${error.toString()}");
    }

    isLoading.value = false;
    return shoppinglist.value;
  }

  Future<List<ShoppinglistItem>> getItemsOfShoppingList(String listUuid) async {
    try {
      var value = await itemRepository.getAllItemList(listUuid);
      isLoading.value = false;
      return value;
    } catch (error) {
      isLoading.value = false;
      errorLog("GetItemsOfShoppingList", error);
    }

    isLoading.value = false;
    return [];
  }

  Future<int?> addItem(ShoppinglistItem item) async {
    try {
      isLoading.value = true;
      var value = await itemRepository.insertItem(item);

      shoppingList.value.items!.add(item);
      isLoading.value = false;
      return value;
    } catch (error) {
      errorLog("getShoppingList", "teste");
      isLoading.value = false;
    }

    isLoading.value = false;
    return null;
  }

  Future<bool?> updateItem(ShoppinglistItem item) async {
    try {
      isLoading.value = true;
      var value = await itemRepository.updateItem(item);
      //shoppingList.value = (await repository.getList(item.listUUID))!;

      for (var i = 0; i < shoppingList.value.items!.length; i++) {
        if (shoppingList.value.items?[i].uuid == item.uuid) {
          shoppingList.value.items?[i] = item;
        }
      }

      return value;
      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;
      errorLog("updateItem", error);
    }

    isLoading.value = false;
    return false;
  }
}
