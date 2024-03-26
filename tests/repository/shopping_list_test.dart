import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/core/database.dart';
import 'package:sumbalist/models/shopping_list.dart';
import 'package:sumbalist/repository/shopping_list_repository.dart';

var mockShoppingList = [
  ShoppingList(
      uuid: "12345",
      userUUID: "userUUID",
      categoryUUID: "categoryUUID",
      statusUUID: "statusUUID",
      name: "name",
      total: 0),
  ShoppingList(
      uuid: "145",
      userUUID: "userID",
      categoryUUID: "categoryUUID",
      statusUUID: "statusUUID",
      name: "nameop",
      total: 0)
];

main() {
  ShoppingListRepository? repository;

  setUp(() async {
    AppDatabase database = AppDatabase(urlDatabase: "ghouse_db.db");
    await database.open("app.db");
    repository = ShoppingListRepository(database);
  });

  test("Insert Shoppinglist", () async {
    var result;

    for (var i = 0; i < mockShoppingList.length; i++)
      result = await repository!.create(mockShoppingList[i]);

    expect(result == 2, true);
  });

  test("Get All list", () async {
    for (var i = 0; i < mockShoppingList.length; i++)
      var result = await repository!.create(mockShoppingList[i]);
    var list = await repository!.getAllList();

    expect(list.length > 0, true);
  });

  test("Delete Shoppinglist", () async {
    await repository!.create(mockShoppingList[0]);
    var result = await repository!.delete(mockShoppingList[0]);
    expect(result, true);
  });

  test("Get Shoppinglist", () async {
    await repository!.create(mockShoppingList[0]);
    var result = await repository!.getList(mockShoppingList[0].uuid);
    expect(result?.uuid, mockShoppingList[0].uuid);
  });
}
