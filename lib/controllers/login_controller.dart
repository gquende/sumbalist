import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/mocks/mocks.dart';
import 'package:sumbalist/models/users.dart';
import 'package:sumbalist/services/firebase_service.dart';
import 'package:sumbalist/utils/utils.dart';

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
    setLoading(true);

    if (usernameFieldController.value.text.isNotEmpty &&
        passwordFieldController.value.text.isNotEmpty) {
      var data = await FirebaseService.auth.signInWithEmailAndPassword(
          email: usernameFieldController.value.text,
          password: passwordFieldController.value.text);

      if (data?.user != null) {
        var user = data.user;

        return User(
            uuid: user?.uid ?? '',
            username: user?.email ?? '',
            name: user?.displayName ?? '',
            surname: user?.displayName ?? '',
            phoneNumber: user?.phoneNumber ?? '');
      }

      await Future.delayed(Duration(seconds: 5));

      setLoading(false);
      return userMock;
    } else {
      Utils.showSnackBar(
          "Erro", "Preencha todos os campos", Icon(Icons.info), Colors.red);
    }
    setLoading(false);
    return null;
  }
}
