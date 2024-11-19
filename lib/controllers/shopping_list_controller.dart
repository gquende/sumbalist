import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/services/firebase_service.dart';

import '../core/error/errorLog.dart';
import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';
import '../models/users.dart';
import '../repository/shopping_list_item_repository.dart';
import '../repository/shopping_list_repository.dart';

class ShoppingListController extends ChangeNotifier {
  TextEditingController nameFieldController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Rx<ShoppingList> shoppingList = ShoppingList.empty().obs;

  int priority = 1;
  var isLoading = false.obs;

  var allShoppingList = <ShoppingList>[].obs;

  ShoppingListRepository repository;
  ShoppingListItemRepository itemRepository;

  ShoppingListController(this.repository, this.itemRepository) {
    priceController.text = "0";
    qtyController.text = "1";
    getAllShoppingList();
  }

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

  //Load Data from Firebase
  Future<void> loadShoppingList(String userUUID) async {
    try {
      var list = await FirebaseService.getShoppingList(userUUID);

      list.forEach((element) {
        createShoppinglist(ShoppingList.fromMap(element));

        //Todo Refactor
        var itemsMap = (element["items"] ?? {}) as Map;
        var itemsList = itemsMap.values.toList();

        //Save Item of Shoppinglist
        for (var i = 0; i < itemsList.length; i++) {
          addItem(ShoppinglistItem.fromMap(itemsList[i]));
        }
      });
    } catch (error, stackTrace) {
      errorLog(error, stackTrace);
    }
  }

  Future<bool> createShoppinglist(ShoppingList shoppingList) async {
    try {
      var item = await repository.create(shoppingList);

      if (item != null && item != 0) {
        allShoppingList.add(shoppingList);
        notifyListeners();
        FirebaseService.saveShoppingList(shoppingList.toMap());
      }
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
      print("DATA:: ${allShoppingList.value}");
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
    } catch (error, stackTrace) {
      isLoading.value = false;
      errorLog(error, stackTrace);
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

      if (value != null && value != 0) {
        notifyListeners();
        FirebaseService.addItemShoppingList(item.toMap());
      }

      return value;
    } catch (error, stackTrace) {
      isLoading.value = false;
      errorLog(error, stackTrace);
    }

    isLoading.value = false;
    return null;
  }

  Future<bool?> removeItem(ShoppinglistItem item) async {
    try {
      isLoading.value = true;
      var value = await itemRepository.deleteItem(item);

      if (value != 0) {
        FirebaseService.deleteItemShoppingList(item.toMap());
      }

      shoppingList.value.items!.remove(item);
      notifyListeners();
      isLoading.value = false;

      return value;
    } catch (error, stackTrace) {
      isLoading.value = false;
      errorLog(error, stackTrace);
    }

    isLoading.value = false;
    return null;
  }

  Future<bool?> updateItem(ShoppinglistItem item) async {
    try {
      isLoading.value = true;
      var value = await itemRepository.updateItem(item);

      FirebaseService.updateItemShoppingList(item.toMap());

      //Todo refactor
      for (var i = 0; i < shoppingList.value.items!.length; i++) {
        if (shoppingList.value.items?[i].uuid == item.uuid) {
          shoppingList.value.items?[i] = item;
        }
      }

      //Update shoppinglist
      notifyListeners();
      resetData();
      isLoading.value = false;
      return value;
    } catch (error, stackTrace) {
      isLoading.value = false;
      errorLog(error, stackTrace);
    }

    isLoading.value = false;
    return false;
  }

  Future<bool?> deleteShoppinglist(ShoppingList list) async {
    try {
      var value = await repository.delete(list);

      allShoppingList.value = allShoppingList.value
          .where((test) => test.uuid != list.uuid)
          .toList();

      notifyListeners();
      if (User.logged?.uuid == list.userUUID) {
        FirebaseService.deleteShoppingList(list.toMap());
      }

      return value;
    } catch (error) {
      debugPrint("${error.toString()}");
    }
    return null;
  }

  Future<bool?> updateShoppinglist(ShoppingList list) async {
    try {
      var value = await repository.update(list);
      notifyListeners();
      FirebaseService.updateShoppingList(list.toMap());
      return value;
    } catch (error) {
      debugPrint("${error.toString()}");
    }
    return null;
  }

  void resetData() {
    this.nameFieldController.text = "";
    this.qtyController.text = "1";
    this.priceController.text = "0";
    this.descriptionController.text = "";
    this.priority = 1;
  }

  bool validateForm(BuildContext context) {
    if (nameFieldController.text.isEmpty ||
        qtyController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preencha todos os campos"),
        backgroundColor: Colors.red,
      ));

      return false;
    } else {
      return true;
    }
  }
}
