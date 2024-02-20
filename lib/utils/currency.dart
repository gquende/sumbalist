import 'package:currency_formatter/currency_formatter.dart';

String formatCurrency(double value) {
  var form = CurrencyFormatterSettings(
    symbol: 'AOA',
    symbolSide: SymbolSide.right,
    thousandSeparator: ' ',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  return CurrencyFormatter.format(value, form);
}
