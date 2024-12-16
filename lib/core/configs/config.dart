import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/firebase_service.dart';

class AppConfig {
  var language = "pt".obs;
  static String appVersion = "1.5.1";

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
              icon: const Icon(
                Icons.info,
                size: 36,
              ),
              title: Text("$label"),
              content: Container(
                width: size.width,
                height: size.height / 8,
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
