import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sumbalist/models/userLocation.dart';
import 'package:sumbalist/services/location_service.dart';

import '../models/users.dart';
import '../pages/home.dart';
import '../services/firebase_service.dart';
import '../utils/utils.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController().obs;
  final surnameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
  PageController pageController = PageController();
  int currentPage = 0;
  Rx<UserLocation> userLocation = UserLocation().obs;
  LocationService locationService = LocationService();
  var isLoading = false.obs;

  SignupController() {
    locationService
        .getUserLocation()
        .then((value) => userLocation.value = value ?? UserLocation());
  }

  Future<User?> createAccount() async {
    try {
      isLoading.value = true;

      var credentials = await FirebaseService.createAccount({
        "username": emailController.value.text,
        "email": emailController.value.text,
        "name": nameController.value.text,
        "password": passwordController.value.text,
        "phone": userLocation.value.idd == null
            ? phoneNumberController.value.text
            : "${userLocation.value.idd}${phoneNumberController.value.text}",
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

  void nextStep(BuildContext context) async {
    switch (currentPage) {
      case 0: //Step 1: Personal information
        {
          if (nameController.value.text.isEmpty ||
              surnameController.value.text.isEmpty) {
            Utils.showSnackBar(
                'Alerta',
                'Preencha todos os campos',
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.pink,
                ),
                Colors.red);
          } else {
            currentPage++;
            pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        }
        break;

      case 1: //Step 2: Access information
        {
          if (!Utils.validateEmail(emailController.value.text)) {
            Utils.showSnackBar(
                'Alerta',
                'Insere um email válido',
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.pink,
                ),
                Colors.red);
          } else if (passwordController.value.text.toString().length < 6) {
            Utils.showSnackBar(
                'Alerta',
                'A palavra dever ter mais 6 caracteres',
                const Icon(
                  FontAwesomeIcons.triangleExclamation,
                  color: Colors.pink,
                ),
                Colors.red);
          } else {
            currentPage++;

            locationService
                .getUserLocation()
                .then((value) => userLocation.value = value ?? UserLocation());
            pageController.nextPage(
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        }
        break;
      case 2: //Step 3: User Currency, Phone Number and Create Account
        {
          await createAccount();
          if (User.logged != null) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
          }
        }

      case 3:
        {}
    }
  }

  void cleanData() {
    nameController.value.clear();
    surnameController.value.clear();
    emailController.value.clear();
    passwordController.value.clear();
    phoneNumberController.value.clear();
    currentPage = 0;
    userLocation.value = UserLocation();
  }




}
