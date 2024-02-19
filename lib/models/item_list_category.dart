import 'package:flutter/cupertino.dart';
import 'package:sumbalist/models/base_model.dart';

class ItemListCategory extends BaseModel {
  String name;
  IconData? icon;

  ItemListCategory(
      {required String uuid,
      required this.name,
      int? id,
      String? created_at,
      String? updated_at,
      this.icon})
      : super(uuid, id, created_at, updated_at);
}
