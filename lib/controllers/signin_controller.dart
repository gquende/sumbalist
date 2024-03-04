import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  RxBool showPassword = true.obs;
  RxBool loading = false.obs;
  final emailFieldController = TextEditingController().obs;
  final passwordFieldController = TextEditingController().obs;

  void setLoading(bool value) {
    loading.value = value;
  }
}
