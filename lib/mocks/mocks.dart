import 'package:sumbalist/models/users.dart';
import 'package:uuid/uuid.dart';

import '../models/shopping_list.dart';
import '../models/shopping_list_item.dart';

Uuid uuidGenerator = Uuid();
var shoplistItemsMock = [
  ShoppinglistItem(
      uuid: "23232",
      isDone: false,
      listUUID: "",
      itemName: "Maracujá",
      description: "Comprar Pão",
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

User userMock = User(
    uuid: uuidGenerator.v4(),
    username: "+233",
    name: "Geraldo",
    surname: "Quende",
    phoneNumber: "926884947",
    password: "123456",
    status: "unregistered");
