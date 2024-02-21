import 'package:flutter/material.dart';

import '../models/shopping_list_categories.dart';

var shoppingListCategoriesMock = <ShoppingListCategory>[
  ShoppingListCategory(uuid: "0", name: "Geral", icon: Icons.category),
  ShoppingListCategory(uuid: "1", name: "Casa", icon: Icons.home),
  ShoppingListCategory(uuid: "2", name: "Festa", icon: Icons.celebration),
  ShoppingListCategory(uuid: "3", name: "Escola", icon: Icons.school)
];

Map<String, IconData> iconCategory = {
  "0": Icons.category,
  "1": Icons.home,
  "2": Icons.celebration,
  "3": Icons.school,
};
