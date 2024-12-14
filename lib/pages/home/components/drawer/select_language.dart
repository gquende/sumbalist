import 'package:flutter/material.dart';
import 'package:sumbalist/core/configs/app_locale.dart';
import 'package:sumbalist/core/di/dependecy_injection.dart';

Widget selectLanguage(BuildContext context) {
  var controller = DI.get<AppLocale>();
  var size = MediaQuery.of(context).size;

  return Container(
    height: size.height / 2,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Column(
          children: controller.avalaible.map((code) {
            return GestureDetector(
              onTap: () async {
                await controller.changeLocale(Locale(code));
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: size.width,
                  height: 55,
                  alignment: Alignment.center,
                  child: Text(
                    controller.getLanguageName(code),
                  ),
                  decoration: BoxDecoration(
                      color: code == controller.locale.value.languageCode
                          ? Theme.of(context).primaryColor.withOpacity(0.3)
                          : Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: code == controller.locale.value.languageCode
                          ? Border.all(color: Theme.of(context).primaryColor)
                          : null),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}
