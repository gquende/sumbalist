import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    try {
      isLoading.value = true;

      debugPrint("${passwordController.value.text.length}");

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
      var credentials = await FirebaseService.createAccount({
        "username": emailController.value.text,
        "email": emailController.value.text,
        "name": nameController.value.text,
        "password": passwordController.value.text,
        "phone": phoneNumberController.value.text,
        "surname": surnameController.value.text
      });

      if (credentials != null) {
        var shared = await SharedPreferences.getInstance();

        User.logged = User(
            uuid: credentials.user?.uid ?? '',
            username: emailController.value.text,
            name: nameController.value.text,
            surname: surnameController.value.text,
            phoneNumber: phoneNumberController.value.text);

        shared.setString("USER", jsonEncode(User.logged?.toMap()));

        await shared.setBool("isFirstTimeRun", false);
        return User.logged;
      }
    } catch (error) {
      debugPrint(error.toString());

      isLoading.value = false;
    }

    isLoading.value = false;
    return null;
  }
}
