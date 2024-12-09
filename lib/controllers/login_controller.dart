import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumbalist/controllers/shopping_list_controller.dart';
import 'package:sumbalist/core/error/errorLog.dart';
import 'package:sumbalist/models/users.dart';
import 'package:sumbalist/services/firebase_service.dart';
import 'package:sumbalist/utils/utils.dart';
import 'package:uuid/uuid.dart';

class LoginController extends GetxController {
  RxBool showPassword = true.obs;
  RxBool loading = false.obs;
  final usernameFieldController = TextEditingController().obs;
  final passwordFieldController = TextEditingController().obs;

  GlobalKey<FormState> formKey = GlobalKey();

  void setLoading(bool value) {
    loading.value = value;
  }

  Future<User?> loginAccount(BuildContext context) async {
    try {
      setLoading(true);

      if (usernameFieldController.value.text.isNotEmpty &&
          passwordFieldController.value.text.isNotEmpty) {
        var data = await FirebaseService.loginAccount(
            usernameFieldController.value.text,
            passwordFieldController.value.text);

        if (data != null) {
          //         print("object");
          var user = User.fromMap(data);
          var shared = await SharedPreferences.getInstance();
          shared.setString("user", jsonEncode(user.toMap()));
          await shared.setBool("isFirstTimeRun", false);

          var shopingListController =
              GetIt.instance.get<ShoppingListController>();

          await shopingListController.loadShoppingList(user.uuid);

          setLoading(false);
          return user;
        } else {
          setLoading(false);
          Utils.showSnackBar("Erro", "Utilizador não encontrado",
              Icon(Icons.info), Colors.red);
        }

        return null;
      } else {
        setLoading(false);
        Utils.showSnackBar(
            "Erro", "Preencha todos os campos", Icon(Icons.info), Colors.red);
      }
      setLoading(false);
    } catch (error) {
      debugPrint(error.toString());
    }

    return null;
  }

  static Future<User?> createTempUser() async {
    try {
      var uuid = Uuid().v4();
      var user = User(
          uuid: uuid,
          username: uuid + "@sumbalist.com",
          name: "Sumbalister",
          surname: "",
          phoneNumber: "",
          status: "unregistered");
      var shared = await SharedPreferences.getInstance();
      shared.setString("user", jsonEncode(user.toMap()));
      User.logged = user;

      FirebaseService.saveTempUser(user.toMap());
      await shared.setBool("isFirstTimeRun", false);

      var shopingListController = GetIt.instance.get<ShoppingListController>();

      await shopingListController.loadShoppingList(user.uuid);

      return user;
    } catch (error, stackTrace) {
      errorLog(error, stackTrace);
    }

    return null;
  }

  /*
  Future<User?> loginWithGoogle() async {
    setLoading(true);
    var credentials = await FirebaseService.loginWithGoogle();

    if (credentials != null) {
      User.logged = User(
          uuid: credentials.uid,
          username: credentials.email ?? '',
          name: credentials.displayName ?? '',
          surname: '',
          phoneNumber: '');

      final SharedPreferences shared = await SharedPreferences.getInstance();
      shared.setString("user", jsonEncode(User.logged?.toMap()));

      await shared.setBool("isFirstTimeRun", false);
      return User.logged;
    }
    setLoading(false);
  }

  */

  static Future<User?> checkUserAuthenticated() async {
    try {
      var shared = await SharedPreferences.getInstance();
      var encodedData = shared.getString("user");

      if (encodedData != null) {
        User.logged = User.fromMap(jsonDecode(encodedData));
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
