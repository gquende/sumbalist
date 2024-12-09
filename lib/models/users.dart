import 'base_model.dart';

class User extends BaseModel {
  String username;
  String phoneNumber;
  String name;
  String surname;
  String? password;
  static User? logged;
  String? status;

  User(
      {required String uuid,
      required this.username,
      required this.name,
      required this.surname,
      required this.phoneNumber,
      this.password,
      required this.status,
      int? id,
      String? created_at,
      String? updated_at})
      : super(uuid, id, created_at, updated_at);

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        uuid: map["uuid"],
        username: map["username"],
        name: map["name"],
        surname: map["surname"],
        phoneNumber: map["phoneNumber"],
        status: map["status"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "uuid": this.uuid,
      "id": this.id,
      "username": this.username,
      "name": this.name,
      "surname": this.surname,
      "phoneNumber": this.phoneNumber,
      "password": this.password,
      "status": this.status,
      "created_at": this.created_at,
      "updated_at": this.updated_at
    };
  }
}
