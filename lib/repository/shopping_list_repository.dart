import 'package:flutter/cupertino.dart';
import 'package:sumbalist/core/error/errorLog.dart';
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
  Future<List<ShoppingList>> getAllList({required String statusUUID}) async {
    try {
      var list = <ShoppingList>[];
      var result;

      devLog("ESTADO:: $statusUUID::");
      if (statusUUID.isEmpty) {
        result =
            await this._appDatabase.db?.rawQuery("SELECT * from ${_table}");
      } else {
        result = await this._appDatabase.db?.rawQuery(
            "SELECT * from ${_table} WHERE statusUUID='${statusUUID}'");

        // result =
        //     await this._appDatabase.db?.rawQuery("SELECT * from ${_table}");

        devLog("TODOS OSD DADOS:: $result");
      }

      if (result != null) {
        for (var i = 0; i < result.length; i++) {
          var shopingList = ShoppingList.fromMap(result[i]);

          devLog("LIST SHOP :: ${shopingList.name}");
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

  //Create a Shoppinglist
  Future<int?> create(ShoppingList item) async {
    try {
      var result = await this._appDatabase.db?.insert(_table, item.toMap());
      debugPrint("${result}");
      return result;
    } catch (error) {
      debugPrint("ShoppingListRepository::Create:: Error ${error.toString()} ");
    }
  }

  //Delete a Shoppinglist
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

  //Update a Shoppinglist
  ///
  /// Passou a usar `update` com parâmetros em vez de uma string de SQL montada
  /// por interpolação. Duas razões, ambas anteriores a esta funcionalidade:
  ///
  /// * O nome da lista ia para dentro de aspas simples sem escape, por isso uma
  ///   lista chamada `Compras d'avó` rebentava a instrução.
  /// * A instrução corria por `rawQuery`, que devolve linhas e não o número de
  ///   registos afetados — a comparação `result == 1` era sempre falsa, e o
  ///   método reportava insucesso mesmo quando gravava.
  Future<bool> update(ShoppingList item) async {
    try {
      final affected = await this._appDatabase.db?.update(
            _table,
            {
              "name": item.name,
              "categoryUUID": item.categoryUUID,
              "statusUUID": item.statusUUID,
              "total": item.total,
              "currencyCode": item.currencyCode,
              "updated_at": item.updated_at,
            },
            where: "uuid = ?",
            whereArgs: [item.uuid],
          );

      return (affected ?? 0) > 0;
    } catch (error, stackTrace) {
      devLog("Error");
      errorLog(error, stackTrace);
    }

    return false;
  }

  //get a ShoppingList based by uuid
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
