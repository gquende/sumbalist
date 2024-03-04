import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:sumbalist/controllers/login_controller.dart';

import '../pages/home.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseDatabase database = FirebaseDatabase.instance;
  static final loginInController = Get.put(LoginController());

  static Future<void> loginAccount() async {
    try {
      loginInController.setLoading(true);
      auth
          .signInWithEmailAndPassword(
        email: loginInController.usernameFieldController.value.text.toString(),
        password:
            loginInController.passwordFieldController.value.text.toString(),
      )
          .then((value) {
        String node =
            value.user!.email!.substring(0, value.user!.email!.indexOf('@'));
        database.ref('Accounts').child(node).onValue.listen((event) {
          //Salvar no SharedPreferences

          Get.to(Home());
          loginInController.setLoading(false);
        }).onError((error, stackTrace) {
          //EM caso de erro

          loginInController.setLoading(false);
        });
      }).onError((error, stackTrace) {
        //Erro de FirebaseBase
        loginInController.setLoading(false);
      });
    } catch (e) {
      //Erro genérico
      loginInController.setLoading(true);
    }
  }
}
