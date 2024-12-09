import 'dart:developer';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import 'package:sumbalist/utils/assets_utils.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/theme/theme.dart';
import '../../shoppinglist/completed_list.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      height: size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Container(
                  height: 30,
                  child: Obx(() {
                    return AppTheme.isDarkMode.value
                        ? Image(image: AssetImage(AssetsUtils.WHITE_LOGO))
                        : Image(image: AssetImage(AssetsUtils.BLACK_LOGO));
                  }),
                ),
                const SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    showCurrencyPicker(
                        context: context,
                        showFlag: true,
                        showSearchField: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        favorite: [
                          AppCurrencyFormat.currency!.code.toLowerCase()
                        ],
                        onSelect: (Currency currency) {
                          AppCurrencyFormat.updateCurrency(currency);

                          setState(() {});
                        },
                        searchHint: "Procurar");

                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (builder) => const CurrencyPage()));
                  },
                  child: Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.monetization_on_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Moeda")
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CompletedShoppingList()));
                  },
                  child: Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.checklist),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Listas concluídas")
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondaryContainer),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.color_lens),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Modo escuro"),
                          ],
                        ),
                        Container(
                          child: LiteRollingSwitch(
                            //initial value
                            value: AppTheme.isDarkMode.value,
                            textOn: 'On',
                            textOff: 'Off',
                            colorOn: Colors.green,
                            colorOff: Colors.redAccent,
                            iconOn: Icons.done,
                            iconOff: Icons.remove_circle_outline,
                            textSize: 10.0,
                            onChanged: (bool state) {
                              //Use it to manage the different states
                              print('Current State of SWITCH IS: $state');
                            },
                            onTap: () {
                              AppTheme.setDarkMode(!AppTheme.isDarkMode.value);
                            },
                            onDoubleTap: () {},
                            onSwipe: () {}, width: 80,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                const Text("from"),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () async {
                    log("Go To GQUENDE PAGE");

                    final Uri url = Uri.parse('https://gquende.com');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: const Text(
                    "GQUENDE",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
