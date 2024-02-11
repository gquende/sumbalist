import '../models/list_categories.dart';
import '../models/shopping_list_item.dart';
import '../models/shopping_list.dart';

var shoplistCategories = <ListCategory>[
  ListCategory(uuid: "1", name: "Geral"),
  ListCategory(uuid: "2", name: "Casa")
];

var shoplistItemsMock = [
  ShoppinglistItem(
      uuid: "23232",
      isDone: false,
      listUUID: "",
      itemName: "Maracujá",
      description: "Comprar para matabicho",
      qty: 2,
      price: 1000.0,
      priority: 1),
  ShoppinglistItem(
      uuid: "23232",
      isDone: true,
      listUUID: "",
      itemName: "Sabão",
      description: "Para para cic",
      qty: 3,
      price: 200.0,
      priority: 1)
];

ShoppingList shoplistMock = ShoppingList(
    uuid: "12345...",
    userUUID: "12345...",
    name: "Teste",
    categoryUUID: "",
    statusUUID: "",
    total: 123,
    items: shoplistItemsMock);

ShoppingList shoplistMock2 = ShoppingList(
    uuid: "12345...",
    userUUID: "12345...",
    name: "Teste",
    categoryUUID: "",
    statusUUID: "",
    total: 123,
    items: shoplistItemsMock);
