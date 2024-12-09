import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/utils/currency.dart';

import '../../../controllers/signup_controller.dart';

class UserPhone extends StatefulWidget {
  const UserPhone({super.key});

  @override
  State<UserPhone> createState() => _UserPhoneState();
}

class _UserPhoneState extends State<UserPhone> {
  var controller = Get.put(SignupController());

  var currency = AppCurrencyFormat.currencies.keys.first.obs;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode:
                                true, // optional. Shows phone code before the country name.
                            onSelect: (Country country) {
                              controller.userLocation.value.idd =
                                  "+${country.phoneCode}";
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            Text(" ${controller.userLocation.value.idd ?? ''}"),
                          ],
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: size.width * 0.70,
                      height: 55,
                      child: TextFormField(
                        controller: controller.phoneNumberController.value,
                        decoration: InputDecoration(
                          hintText: "",
                          contentPadding: EdgeInsets.only(bottom: 10),
                          filled: true,
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          border: OutlineInputBorder(),
                          fillColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                )),
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
                      setState(() {
                        currency.value = value!;
                      });
                      // AppCurrencyFormat.setConfig(value!);
                    },
                    items: AppCurrencyFormat.currencies.keys
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    dropdownColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
