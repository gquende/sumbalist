import 'package:flutter/cupertino.dart';

import 'base_model.dart';

class ShoppingListCategory extends BaseModel {
  String name;
  IconData? icon;

  ShoppingListCategory(
      {required String uuid,
      required this.name,
      int? id,
      String? created_at,
      String? updated_at,
      this.icon})
      : super(uuid, id, created_at, updated_at);
}
