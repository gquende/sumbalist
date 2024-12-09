import 'dart:convert';

import 'package:currency_formatter/currency_formatter.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCurrencyFormat {
  static Map<String, String> currencies = {
    "Kzs": "AOA",
    "USD": "usd",
    "EUR": "eur",
    "REAL": "real"
  };
  static var formater = CurrencyFormat.usd.obs;

  static Currency? currency;

  static updateCurrency(Currency cu) async {
    currency = cu;
    formater.value = CurrencyFormat(
      symbol: cu.symbol,
      symbolSide: cu.symbolOnLeft ? SymbolSide.left : SymbolSide.right,
      thousandSeparator: cu.code == "AOA" ? '.' : cu.thousandsSeparator,
      decimalSeparator: cu.code == "AOA" ? ',' : cu.decimalSeparator,
      symbolSeparator: cu.spaceBetweenAmountAndSymbol ? ' ' : '',
    );

    var shared = await SharedPreferences.getInstance();
    shared.setString("currency", jsonEncode(cu));
  }

  static Future init() async {
    var shared = await SharedPreferences.getInstance();

    String? currency = shared.getString("currency");

    if (currency != null) {
      Currency cu = Currency.from(json: jsonDecode(currency));
      updateCurrency(cu);
    } else {
      var cu = Currency(
          code: 'AOA',
          name: 'Angolan Kwanza',
          symbol: 'AOA',
          flag: 'AO',
          number: 973,
          decimalDigits: 2,
          namePlural: 'Angolan Kwanzas',
          symbolOnLeft: false,
          decimalSeparator: ',',
          thousandsSeparator: ' ',
          spaceBetweenAmountAndSymbol: true);
      updateCurrency(cu);
    }

    // setConfig(currency);
  }

  // static setConfig(String currency) async {
  //   var shared = await SharedPreferences.getInstance();
  //   shared.setString("currency", currency);
  //
  //   switch (currency) {
  //     case "Kzs":
  //       formater = const CurrencyFormat(
  //         symbol: 'AOA',
  //         symbolSide: SymbolSide.right,
  //         thousandSeparator: ' ',
  //         decimalSeparator: ',',
  //         symbolSeparator: ' ',
  //       );
  //       break;
  //
  //     case "REAL":
  //       formater = const CurrencyFormat(
  //         symbol: 'R\$',
  //         symbolSide: SymbolSide.left,
  //         thousandSeparator: ' ',
  //         decimalSeparator: ',',
  //         symbolSeparator: ' ',
  //       );
  //       break;
  //     default:
  //       formater = CurrencyFormat.fromCode(currencies[currency]!)!;
  //       break;
  //   }
  // }

  static String format(double value) {
    return CurrencyFormatter.format(value, formater.value);
  }
}
