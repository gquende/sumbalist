import 'dart:developer' as dev;
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/controllers/currency_controller.dart';
import 'package:sumbalist/core/configs/app_locale.dart';
import 'package:sumbalist/pages/home/components/drawer/select_language.dart';
import 'package:sumbalist/utils/assets_utils.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/dependecy_injection.dart';
import '../../../../utils/theme/theme.dart';
import '../../../shoppinglist/completed_list.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late CurrencyController currencyController;
  int value = 0;
  int? nullableValue;
  bool positive = false;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState

    currencyController = context.read<CurrencyController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localization = DI.get<AppLocale>();
    const green = Color(0xFF45CC0D);
    var size = MediaQuery.of(context).size;
    // final isDarkTheme = theme.brightness == Brightness.dark;
    return ListenableBuilder(
        listenable: Listenable.merge([localization]),
        builder: (_, __) {
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
                              : Image(
                                  image: AssetImage(AssetsUtils.BLACK_LOGO));
                        }),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Divider(
                        height: 10,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const CompletedShoppingList()));
                        },
                        child: Container(
                          width: size.width,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.checklist),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  localization.strings.completedLists,
                                )
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
                                currencyController.updateCurrency(currency);
                              },
                              searchHint: "Procurar");
                        },
                        child: Container(
                          width: size.width,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.monetization_on_rounded),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(localization.strings.currency)
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
                          dev.log("Seleccionar língua");

                          Get.bottomSheet(
                            selectLanguage(context),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ).then((value) {
                            setState(() {});
                          });
                          setState(() {});
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => const CompletedShoppingList()));
                        },
                        child: Container(
                          width: size.width,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.translate),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(localization.strings.language)
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
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.color_lens),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(localization.strings.darkMode),
                                ],
                              ),
                              Container(
                                width: 70,
                                child: DefaultTextStyle.merge(
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                  child: IconTheme.merge(
                                    data: const IconThemeData(
                                        color: Colors.white),
                                    child: AnimatedToggleSwitch<bool>.dual(
                                      current: AppTheme.isDarkMode.value,
                                      first: false,
                                      second: true,
                                      spacing: 15.0,
                                      animationDuration:
                                          const Duration(milliseconds: 600),
                                      style: const ToggleStyle(
                                        borderColor: Colors.transparent,
                                        indicatorColor: Colors.white,
                                        backgroundColor: Colors.black,
                                      ),
                                      customStyleBuilder:
                                          (context, local, global) {
                                        if (global.position <= 0.0) {
                                          return ToggleStyle(
                                              backgroundColor: Colors.red[800]);
                                        }
                                        return ToggleStyle(
                                            backgroundGradient: LinearGradient(
                                          colors: [green, Colors.red[800]!],
                                          stops: [
                                            global.position -
                                                (1 -
                                                        1 *
                                                            max(
                                                                0,
                                                                global.position -
                                                                    0.1)) *
                                                    0.2,
                                            global.position +
                                                max(
                                                        0,
                                                        1 *
                                                            (global.position -
                                                                0.1)) *
                                                    0.2,
                                          ],
                                        ));
                                      },
                                      borderWidth: 4.0,
                                      height: 35.0,
                                      loadingIconBuilder: (context, global) =>
                                          CupertinoActivityIndicator(
                                              color: Color.lerp(Colors.red[800],
                                                  green, global.position)),
                                      onChanged: (b) async {
                                        await AppTheme.setDarkMode(b);

                                        setState(() {});
                                      },
                                      iconBuilder: (value) => value
                                          ? const Icon(
                                              Icons.power_settings_new_rounded,
                                              color: green,
                                              size: 18.0)
                                          : Icon(
                                              Icons.power_settings_new_rounded,
                                              color: Colors.red[800],
                                              size: 18.0),
                                      textBuilder: (value) => value
                                          ? const Center(child: Text('On'))
                                          : const Center(child: Text('Off')),
                                    ),
                                  ),
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
                      const Text("by"),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          final Uri url =
                              Uri.parse('https://www.linkedin.com/in/gquende/');
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
        });
  }
}
