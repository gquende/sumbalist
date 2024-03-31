import 'package:flutter/cupertino.dart';

import 'base_model.dart';
import 'shopping_list_item.dart';

class ShoppingList extends BaseModel {
  String userUUID;
  String categoryUUID;
  String statusUUID;
  String name;
  List<ShoppinglistItem>? items = [];
  double total;

  ShoppingList(
      {required String uuid,
      required this.userUUID,
      required this.categoryUUID,
      required this.statusUUID,
      required this.name,
      required this.total,
      int? id,
      this.items,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);

  factory ShoppingList.fromMap(Map map) {
    return ShoppingList(
        uuid: map["uuid"],
        userUUID: map["userUUID"],
        name: map["name"],
        categoryUUID: map["categoryUUID"],
        statusUUID: map["statusUUID"],
        items: [],
        total: double.parse("${map["total"] ?? 0}"));
  }

  Map<String, dynamic> toMap() {
    return {
      "uuid": this.uuid,
      "id": this.id,
      "userUUID": this.userUUID,
      "name": this.name,
      "categoryUUID": this.categoryUUID,
      "statusUUID": this.statusUUID,
      "total": this.total,
      "created_at": this.created_at,
      "updated_at": this.updated_at
    };
  }

  calculateTotal() {
    double total = 0;
    this.items!.forEach((element) {
      total += element.totalPrice();
    });

    return total;
  }

  calculateTotalBuyed() {
    double total = 0;
    this.items!.forEach((element) {
      if (element.isDone == true) {
        debugPrint("${element.toString()} Calucalted");
        total += element.totalPrice();
      }
    });

    return total;
  }

  calculateTotalItemBuyed() {
    int total = 0;
    this.items!.forEach((element) {
      if (element.isDone == true) {
        total++;
      }
    });

    return total;
  }

  calculateTotalItemPending() {
    int total = 0;
    this.items!.forEach((element) {
      if (element.isDone == false) {
        total++;
      }
    });

    return total;
  }

  double getPercentBuyed() {
    return double.parse(
        "${((calculateTotalBuyed() / (calculateTotal() == 0 ? 1 : calculateTotal())) * 100)}");
  }

  double getPercentBuyedByItem() {
    return double.parse(
        "${((calculateTotalItemBuyed() / ((items?.length) == 0 ? 1 : items?.length)) * 100)}");
  }
}
