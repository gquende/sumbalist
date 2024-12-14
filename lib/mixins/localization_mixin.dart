import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sumbalist/core/configs/app_locale.dart';
import 'package:sumbalist/core/di/dependecy_injection.dart';

mixin LocalizationMixin<T extends StatefulWidget> on State<T> {
  AppLocalizations get strings => DI.get<AppLocale>().strings!;
}
