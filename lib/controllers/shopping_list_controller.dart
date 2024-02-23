import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  var allShoppingList = <ShoppingList>[].obs;

  ShoppingListRepository repository;
  ShoppingListItemRepository itemRepository;

  ShoppingListController(this.repository, this.itemRepository);

  Future<ShoppingList?> getShoppingList(String uuid) async {
    try {
      isLoading.value = true;
      var value = await repository.getList(uuid);

      isLoading.value = false;
      return value;
    } catch (error) {
      isLoading.value = false;

      debugPrint(
          "ShoppinglistController:: getShoppingList::ERROR : ${error.toString()}");
    }

    isLoading.value = false;
    return null;
  }

  Future<bool> createShoppinglist(ShoppingList shoppingList) async {
    try {
      var item = await repository.create(shoppingList);
      await getAllShoppingList();

      return true;
    } catch (error) {
      debugPrint(error.toString());
    }

    return false;
  }

  Future<List<ShoppingList>> getAllShoppingList() async {
    try {
      isLoading.value = true;
      allShoppingList.value = await repository.getAllList();

      isLoading.value = false;
    } catch (error) {
      isLoading.value = false;

      debugPrint(
          "ShoppinglistController:: getShoppingList::ERROR : ${error.toString()}");
    }

    isLoading.value = false;
    return allShoppingList.value;
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
      isLoading.value = false;
      resetData();
      return value;
    } catch (error) {
      errorLog("getShoppingList", "teste");
      isLoading.value = false;
    }

    isLoading.value = false;
    return null;
  }

  Future<bool?> removeItem(ShoppinglistItem item) async {
    try {
      isLoading.value = true;
      var value = await itemRepository.deleteItem(item);

      shoppingList.value.items!.remove(item);
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

      //Update shoppinglist

      resetData();
      isLoading.value = false;
      return value;
    } catch (error) {
      isLoading.value = false;
      errorLog("updateItem", error);
    }

    isLoading.value = false;
    return false;
  }

  Future<bool?> deleteShoppinglist(ShoppingList list) async {
    try {
      var value = await repository.delete(list);
      getAllShoppingList();

      return value;
    } catch (error) {
      debugPrint("${error.toString()}");
    }
  }

  Future<bool?> updateShoppinglist(ShoppingList list) async {
    try {
      var value = await repository.update(list);
      //getAllShoppingList();

      return value;
    } catch (error) {
      debugPrint("${error.toString()}");
    }
  }

  void resetData() {
    this.nameFieldController.text = "";
    this.qtyController.text = "";
    this.priceController.text = "";
    this.descriptionController.text = "";
    this.priority = 1;
  }

  bool validateForm(BuildContext context) {
    if (nameFieldController.text.isEmpty ||
        qtyController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Preencha todos os campos"),
        backgroundColor: Colors.red,
      ));

      return false;
    } else {
      return true;
    }
  }
}
