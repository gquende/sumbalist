import 'package:currency_formatter/currency_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCurrencyFormat {
  static Map<String, String> currencies = {
    "Kzs": "AOA",
    "USD": "usd",
    "EUR": "eur",
    "REAL": "real"
  };
  static CurrencyFormat formater = CurrencyFormat.usd;

  static Future init() async {
    var shared = await SharedPreferences.getInstance();
    String currency = shared.getString("currency") ?? "Kzs";
    setConfig(currency);
  }

  static setConfig(String currency) async {
    var shared = await SharedPreferences.getInstance();
    shared.setString("currency", currency);

    switch (currency) {
      case "Kzs":
        formater = const CurrencyFormat(
          symbol: 'AOA',
          symbolSide: SymbolSide.right,
          thousandSeparator: ' ',
          decimalSeparator: ',',
          symbolSeparator: ' ',
        );
        break;

      case "REAL":
        formater = const CurrencyFormat(
          symbol: 'R\$',
          symbolSide: SymbolSide.left,
          thousandSeparator: ' ',
          decimalSeparator: ',',
          symbolSeparator: ' ',
        );
        break;
      default:
        formater = CurrencyFormat.fromCode(currencies[currency]!)!;
        break;
    }
  }

  static String format(double value) {
    return CurrencyFormatter.format(value, formater);
  }
}
