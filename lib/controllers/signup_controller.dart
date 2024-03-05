import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController().obs;
  final surnameController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final password = TextEditingController().obs;
  final phoneNumberController = TextEditingController().obs;
}
