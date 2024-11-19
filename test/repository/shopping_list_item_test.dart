import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/core/database.dart';
import 'package:sumbalist/models/shopping_list_item.dart';
import 'package:sumbalist/repository/shopping_list_item_repository.dart';

var mockItemList = [
  ShoppinglistItem(
      uuid: "234",
      isDone: true,
      listUUID: "1",
      itemName: "itemName",
      description: "description",
      qty: 3,
      price: 20000,
      priority: 2),
  ShoppinglistItem(
      uuid: "1",
      isDone: false,
      listUUID: "1",
      itemName: "itemName",
      description: "description",
      qty: 3,
      price: 20000,
      priority: 2)
];

main() {
  ShoppingListItemRepository? repository;

  setUp(() async {
    AppDatabase database = AppDatabase();
    await database.open("app.db");
    repository = ShoppingListItemRepository(database);
  });

  test("Insert Item", () async {
    var result;

    for (var i = 0; i < mockItemList.length; i++)
      result = await repository!.insertItem(mockItemList[i]);

    expect(result == 2, true);
  });

  test("Get All list", () async {
    for (var i = 0; i < mockItemList.length; i++)
      var result = await repository!.insertItem(mockItemList[i]);
    var list = await repository!.getAllItemList("1");

    expect(list.length > 0, true);
  });

  test("Delete Item", () async {
    await repository!.insertItem(mockItemList[0]);
    var result = await repository!.deleteItem(mockItemList[0]);
    expect(result, true);
  });

  test("Get Item", () async {
    await repository!.insertItem(mockItemList[0]);
    var result = await repository!.getItemList(mockItemList[0].uuid);
    expect(result?.uuid, mockItemList[0].uuid);
  });

  test("Update Item", () async {
    await repository!.insertItem(mockItemList[0]);
    mockItemList[0].itemName = "quende";
    var result = await repository!.updateItem(mockItemList[0]);
    var item = await repository!.getItemList(mockItemList[0].uuid);
    expect(item?.itemName, "quende");
  });
}
