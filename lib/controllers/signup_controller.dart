import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../models/users.dart';
import '../services/firebase_service.dart';
import '../utils/utils.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController().obs;
  final surnameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  var isLoading = false.obs;

  Future<User?> createAccount() async {
    isLoading.value = true;

    if (!Utils.validateEmail(emailController.value.text)) {
      Utils.showSnackBar(
          'Warning',
          'Enter Correct Email',
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pink,
          ),
          Colors.red);

      isLoading.value = false;
      return null;
    }
    if (passwordController.value.text.toString().length < 6) {
      Utils.showSnackBar(
          'Warning',
          'Password length should greater than 5',
          const Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Colors.pink,
          ),
          Colors.red);
      isLoading.value = false;

      return null;
    }
    FirebaseService.createAccount({
      "username": emailController.value.text,
      "email": emailController.value.text,
      "name": nameController.value.text,
      "password": passwordController.value.text,
      "phone": phoneNumberController.value.text,
      "surname": surnameController.value.text
    });

    isLoading.value = false;
  }
}
