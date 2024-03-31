import 'base_model.dart';

class ShoppinglistItem extends BaseModel {
  String listUUID;
  String itemName;
  int qty = 1;
  double price;
  bool isDone = false;
  String description;
  int priority;

  ShoppinglistItem(
      {required String uuid,
      required this.isDone,
      required this.listUUID,
      required this.itemName,
      required this.description,
      required this.qty,
      required this.price,
      required this.priority,
      int? id,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);

  double totalPrice() {
    return this.price * this.qty;
  }

  Map<String, Object?> toMap() {
    return {
      "listUUID": this.listUUID,
      "uuid": this.uuid,
      "itemName": this.itemName,
      "description": this.description,
      "qty": this.qty,
      "price": this.price,
      "priority": this.priority,
      "created_at": this.created_at,
      "updated_at": this.updated_at,
      "isDone": this.isDone == true ? 1 : 0
    };
  }

  factory ShoppinglistItem.fromMap(Map map) {
    return ShoppinglistItem(
        uuid: map["uuid"],
        isDone: map["isDone"] == 1,
        listUUID: map["listUUID"],
        itemName: map["itemName"],
        description: map["description"],
        qty: map["qty"],
        price: map["price"],
        priority: map["priority"],
        id: map["id"],
        created_at: map["created_at"],
        updated_at: map["updated_at"]);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "(Id:${this.id}, ItemName:${this.itemName}, isDone: ${this.isDone})";
  }
}
