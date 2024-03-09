import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller.dart';

Widget UserCredentials(BuildContext context) {
  var size = MediaQuery.of(context).size;
  var controller = Get.put(SignupController());

  return Container(
    width: size.width,
    height: size.height / 2,
    child: Column(
      children: [
        Container(
          width: size.width,
          height: 55,
          decoration: BoxDecoration(
              color: Color(0xffe5e5e5),
              borderRadius: BorderRadius.circular(50)),
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
                    color: Color(0xff000000),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  fillColor: Color(0xffe5e5e5),
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
              color: Color(0xffe5e5e5),
              borderRadius: BorderRadius.circular(50)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: controller.passwordController.value,
              decoration: InputDecoration(
                  hintText: "password",
                  contentPadding: EdgeInsets.only(bottom: 10),
                  focusColor: Color(0xff000000),
                  filled: true,
                  prefixIcon: Icon(
                    CupertinoIcons.padlock_solid,
                    color: Color(0xff000000),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(11))),
                  fillColor: Color(0xffe5e5e5),
                  labelStyle: TextStyle(color: Color(0xff000000)),
                  border: OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: Icon(Icos),
                  )),
            ),
          ),
        ),
      ],
    ),
  );
}
