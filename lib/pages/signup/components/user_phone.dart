import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/utils/currency.dart';

import '../../../controllers/signup_controller.dart';

Widget UserPhone(BuildContext context) {
  var size = MediaQuery.of(context).size;
  var controller = Get.put(SignupController());

  var currency = AppCurrencyFormat.currencies.keys.first.obs;

  return Container(
    width: size.width,
    height: size.height / 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
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
              controller: controller.phoneNumberController.value,
              decoration: InputDecoration(
                  hintText: "Número de telefone",
                  contentPadding: EdgeInsets.only(bottom: 10),
                  focusColor: Color(0xff000000),
                  filled: true,
                  prefixIcon: Icon(
                    CupertinoIcons.phone,
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
        Text("Moeda"),
        SizedBox(
          height: 10,
        ),
        Obx(
          () => Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                    underline: null,
                    isExpanded: true,
                    value: currency.value,
                    onChanged: (value) {
                      currency.value = value!;
                      AppCurrencyFormat.setConfig(value);
                    },
                    items: AppCurrencyFormat.currencies.keys
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList()),
              )),
        )
      ],
    ),
  );
}
