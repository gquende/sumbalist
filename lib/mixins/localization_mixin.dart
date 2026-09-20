import 'package:flutter/cupertino.dart';

import 'package:sumbalist/l10n/app_localizations.dart';
import 'package:sumbalist/core/configs/app_locale.dart';
import 'package:sumbalist/core/di/dependecy_injection.dart';

/// Traduções para widgets com estado.
mixin LocalizationMixin<T extends StatefulWidget> on State<T> {
  AppLocalizations get strings => DI.get<AppLocale>().strings;
}

/// Traduções para widgets sem estado.
///
/// As traduções vêm do [AppLocale] registado no contentor de dependências, não
/// do [BuildContext], por isso um [StatelessWidget] pode lê-las directamente —
/// o mixin acima só existe porque está preso a `State`.
AppLocalizations get appStrings => DI.get<AppLocale>().strings;
