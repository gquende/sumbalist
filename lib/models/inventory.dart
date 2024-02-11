import 'base_model.dart';

class Inventory extends BaseModel {
  String userUUID;
  String inventoryUUID;
  String description;
  String qty;
  String? price;
  String purchaseDate;
  String? expirationDate;
  String? consumptionDate;
  String statusUUID;

  Inventory(
      {required String uuid,
      required this.userUUID,
      required this.inventoryUUID,
      required this.description,
      required this.qty,
      this.price,
      required this.purchaseDate,
      this.expirationDate,
      required this.statusUUID,
      int? id,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);
}
