import 'package:currency_formatter/currency_formatter.dart';

String appCurrencyFormat(double value) {
  var form = CurrencyFormatterSettings(
    symbol: 'AOA',
    symbolSide: SymbolSide.right,
    thousandSeparator: ' ',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  return CurrencyFormatter.format(value, form);
}
