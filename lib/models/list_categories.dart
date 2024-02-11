import 'base_model.dart';

class ListCategory extends BaseModel {
  String name;

  ListCategory(
      {required String uuid,
      required this.name,
      int? id,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);
}
