import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller.dart';

Widget UserPhone(BuildContext context) {
  var size = MediaQuery.of(context).size;
  var controller = Get.put(SignupController());

  return Container(
    width: size.width,
    height: size.height / 2,
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: size.width,
          height: 55,
          decoration: BoxDecoration(
              color: Color(0xffe5e5e5), borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: controller.phoneNumberController.value,
              decoration: InputDecoration(
                  hintText: "Número de telefone",
                  contentPadding: EdgeInsets.only(bottom: 10),
                  focusColor: Color(0xff000000),
                  filled: true,
                  prefixIcon: Icon(
                    CupertinoIcons.phone,
                    color: Color(0xff000000),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  fillColor: Color(0xffe5e5e5),
                  labelStyle: TextStyle(color: Color(0xff000000)),
                  border: OutlineInputBorder()),
            ),
          ),
        ),
      ],
    ),
  );
}
