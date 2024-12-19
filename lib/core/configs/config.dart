import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/utils/theme/theme.dart';

import '../../services/firebase_service.dart';

class AppConfig {
  var language = "pt".obs;
  static String appVersion = "1.5.2";

  AppConfig() {
    // getLocale();
  }

  static Future<void> checkVersion(
      {BuildContext? context, String? label, String? message}) async {
    var last_version = await FirebaseService.getAppVersion();

    if (last_version != null) if (appVersion != last_version) {
      if (context != null) {
        var size = MediaQuery.of(context).size;
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              icon: Icon(
                Icons.info,
                size: 36,
                color: AppTheme.isDarkMode.value ? Colors.white : Colors.black,
              ),
              title: Text("$label"),
              content: Container(
                width: size.width,
                height: size.height / 9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$message",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    }
  }
}
