import 'package:currency_picker/src/currency.dart';
import 'package:flutter/cupertino.dart';

import '../utils/currency.dart';

class CurrencyController extends ChangeNotifier {
  void updateCurrency(Currency currency) {
    AppCurrencyFormat.updateCurrency(currency);
    notifyListeners();
  }
}
