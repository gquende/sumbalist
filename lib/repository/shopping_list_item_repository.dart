import 'package:flutter/cupertino.dart';

import '../core/database.dart';
import '../models/shopping_list_item.dart';

class ShoppingListItemRepository<T> {
  final String _table = "shopping_list_items";
  final AppDatabase _appDatabase;

  ShoppingListItemRepository(this._appDatabase);

  //Get all ShoppingList
  Future<List<ShoppinglistItem>> getAllItemList(String listUUID) async {
    try {
      var list = <ShoppinglistItem>[];
      var result = await this._appDatabase.db?.rawQuery(
        "SELECT * from ${_table} where listUUID='${listUUID}' order by isDone",
        [],
      );
      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          var item = ShoppinglistItem.fromMap(result[i]);

          debugPrint(item.toString());

          list.add(item);
        }
      }
      return list;
    } catch (error) {
      debugPrint(
          "SHOPLISTITEM_REPOSITORY::getItemForAShoppingList:: Error ${error.toString()} ");
    }

    return <ShoppinglistItem>[];
  }

  Future<int?> insertItem(ShoppinglistItem item) async {
    try {
      var result = await this._appDatabase.db?.insert(_table, item.toMap());

      return result;
    } catch (error) {
      debugPrint(
          "ShoppingListItemRepository::InsertItem:: Error ${error.toString()} ");
    }
  }

  Future<bool> deleteItem(ShoppinglistItem item) async {
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
          "SHOPLISTITEM_REPOSITORY::deleteItem:: Error ${error.toString()} ");
    }

    return false;
  }

  Future<bool> updateItem(ShoppinglistItem item) async {
    try {
      var result = await this._appDatabase.db?.update(_table, item.toMap(),
          where: "uuid=?", whereArgs: [item.uuid]);

      if (result != null) {
        return result == 1;
      }
    } catch (error) {
      debugPrint(
          "SHOPLISTITEM_REPOSITORY::updateItem:: Error ${error.toString()} ");
    }

    return false;
  }

  Future<ShoppinglistItem?> getItemList(String uuid) async {
    try {
      ShoppinglistItem? item = null;
      var result = await this
          ._appDatabase
          .db
          ?.rawQuery("SELECT * from ${_table} where uuid= '${uuid}'");
      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          item = ShoppinglistItem.fromMap(result[i]);
        }
      }
      return item;
    } catch (error) {
      debugPrint(
          "SHOPLISTITEM_REPOSITORY::getItemForAShoppingList:: Error ${error.toString()} ");
    }

    return null;
  }
}
