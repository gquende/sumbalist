import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocale extends ValueNotifier {
  var avalaible = ["pt", "en"];

  late AppLocalizations _strings;

  var locale = Locale(Platform.localeName.split('_').first).obs;

  AppLocale(super.value);

//  Locale get locale => _locale.value;

  AppLocalizations get strings => _strings;

  Future<void> load() async {
    var code = await getLocale();
    locale.value = Locale(code);
    _strings = await AppLocalizations.delegate.load(locale.value);
  }

  Future<void> changeLocale(Locale local) async {
    if (locale == local) return;
    locale.value = local;
    _strings = await AppLocalizations.delegate.load(locale.value);

    await saveLocale(local);
    notifyListeners();
  }

  Future<String> getLocale() async {
    var shared = await SharedPreferences.getInstance();
    return await shared.getString("locale") ??
        Platform.localeName.split('_').first;
  }

  Future<void> saveLocale(Locale locale) async {
    var shared = await SharedPreferences.getInstance();
    await shared.setString("locale", locale.languageCode);
  }

  getLanguageName(String code) {
    return switch (code) {
      'en' => 'English',
      'pt' => 'Português',
      _ => throw Exception('Locale not found'),
    };
  }
}
