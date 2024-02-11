import 'package:flutter/cupertino.dart';

import '../core/database.dart';
import '../models/users.dart' as usermodel;

class UserRepository {
  final String _userTable = "users";
  final AppDatabase appDatabase;

  UserRepository({required this.appDatabase});
  //Get user in storage with username and password
  Future<usermodel.User?> getUserByUsernameAndPassword(
      String username, String password) async {
    try {
      var result = await this.appDatabase.db?.rawQuery(
        "SELECT uuid, username,name,surname from ${_userTable} where username=?1 and password=?2",
        [username, password],
      );
      usermodel.User? user;
      result?.forEach((element) {
        user = usermodel.User.fromMap(element);
      });

      return user;
    } catch (error) {
      debugPrint(
          "USER_REPOSITORY::GetUserByUsernameAndPassword:: Error ${error.toString()} ");
    }
  }

  Future<int?> create(usermodel.User user) async {
    try {
      var result = await this.appDatabase.db?.insert(_userTable, user.toMap());
      debugPrint("${result}");
      return result;
    } catch (error) {
      debugPrint("USER_REPOSITORY::Create:: Error ${error.toString()} ");
    }
  }
}
