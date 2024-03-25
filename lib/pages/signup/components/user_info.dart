import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller.dart';

Widget UserInfo(BuildContext context) {
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
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: controller.nameController.value,
              decoration: InputDecoration(
                hintText: "Nome",
                contentPadding: EdgeInsets.only(bottom: 10),
                filled: true,
                prefixIcon: Icon(
                  CupertinoIcons.person,
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                border: OutlineInputBorder(),
                fillColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
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
            child: TextFormField(
              controller: controller.surnameController.value,
              decoration: InputDecoration(
                  hintText: "Sobrenome",
                  contentPadding: EdgeInsets.only(bottom: 10),
                  focusColor: Color(0xff000000),
                  filled: true,
                  prefixIcon: Icon(
                    CupertinoIcons.person,
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
      ],
    ),
  );
}
