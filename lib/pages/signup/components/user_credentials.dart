import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller.dart';

Widget UserCredentials(BuildContext context) {
  var size = MediaQuery.of(context).size;
  var controller = Get.put(SignupController());

  var isObscure = true.obs;

  return Container(
    width: size.width,
    height: size.height / 2,
    child: Column(
      children: [
        Container(
          width: size.width,
          height: 55,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: controller.emailController.value,
              decoration: InputDecoration(
                  hintText: "Email",
                  contentPadding: EdgeInsets.only(bottom: 10),
                  focusColor: Color(0xff000000),
                  filled: true,
                  prefixIcon: Icon(
                    CupertinoIcons.mail,
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  fillColor: Theme.of(context).colorScheme.secondaryContainer,
                  labelStyle: TextStyle(color: Color(0xff000000)),
                  border: OutlineInputBorder()),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: size.width,
          height: 55,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() {
                return TextFormField(
                  controller: controller.passwordController.value,
                  obscureText: isObscure.value,
                  decoration: InputDecoration(
                      hintText: "password",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      prefixIcon: Icon(
                        CupertinoIcons.padlock,
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(color: Color(0xff000000)),
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          isObscure.value = !isObscure.value;
                        },
                        child: Icon(Icons.remove_red_eye),
                      )),
                );
              })),
        ),
      ],
    ),
  );
}
