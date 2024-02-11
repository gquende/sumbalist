import 'package:flutter/cupertino.dart';
import 'package:sumbalist/repository/shopping_list_item_repository.dart';

import '../core/database.dart';
import '../models/shopping_list.dart';

class ShoppingListRepository {
  final String _table = "shopping_lists";
  final AppDatabase _appDatabase;
  ShoppingListItemRepository? itemRepository;

  ShoppingListRepository(this._appDatabase) {
    this.itemRepository = ShoppingListItemRepository(this._appDatabase);
  }

  //Get all ShoppingList
  Future<List<ShoppingList>> getAllList() async {
    try {
      var list = <ShoppingList>[];
      var result = await this._appDatabase.db?.rawQuery(
        "SELECT * from ${_table}",
        [],
      );
      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          var shopingList = ShoppingList.fromMap(result[i]);
          shopingList.items =
              await itemRepository?.getAllItemList(shopingList.uuid);

          list.add(shopingList);
        }
      }
      return list;
    } catch (error) {
      debugPrint(
          "ShoppingListRepository::getAllList: Error ${error.toString()} ");
    }

    return <ShoppingList>[];
  }

  Future<int?> create(ShoppingList item) async {
    try {
      var result = await this._appDatabase.db?.insert(_table, item.toMap());
      debugPrint("${result}");
      return result;
    } catch (error) {
      debugPrint("ShoppingListRepository::Create:: Error ${error.toString()} ");
    }
  }

  Future<bool> delete(ShoppingList item) async {
    try {
      var result = await this
          ._appDatabase
          .db
          ?.delete(_table, where: "uuid=?", whereArgs: [item.uuid]);

      if (result != null) {
        return result == 1;
      }
    } catch (error) {
      debugPrint(
          "${this.runtimeType.toString()}::deleteItem:: Error ${error.toString()} ");
    }

    return false;
  }

  Future<bool> update(ShoppingList item) async {
    try {
      var result = await this._appDatabase.db?.update(_table, item.toMap(),
          where: "uuid=?", whereArgs: [item.uuid]);

      if (result != null) {
        return result == 1;
      }
    } catch (error) {
      debugPrint(
          "${this.runtimeType.toString()}::updateItem:: Error ${error.toString()} ");
    }

    return false;
  }

  Future<ShoppingList?> getList(String uuid) async {
    try {
      ShoppingList? shoppingList;
      var result = await this._appDatabase.db?.rawQuery(
        "SELECT * from ${_table} where uuid='${uuid}'",
        [],
      );
      var list = [];
      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          shoppingList = ShoppingList.fromMap(result[i]);
        }
      }
      return shoppingList;
    } catch (error) {
      debugPrint(
          "ShoppingListRepository::getAllList: Error ${error.toString()} ");
    }
    return null;
  }
}
