import 'base_model.dart';

class User extends BaseModel {
  String username;
  String name;
  String surname;
  String? password;

  static User? logged;

  User(
      {required String uuid,
      required this.username,
      required this.name,
      required this.surname,
      this.password,
      int? id,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uuid: map["uuid"],
        username: map["username"],
        name: map["name"],
        surname: map["surname"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uuid": this.uuid,
      "id": this.id,
      "username": this.username,
      "name": this.name,
      "surname": this.surname,
      "password": this.password,
      "created_at": this.created_at,
      "updated_at": this.updated_at
    };
  }
}
