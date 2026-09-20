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

  /// Moeda predefinida do utilizador. É a que vale para qualquer lista que não
  /// tenha escolhido uma.
  static var formater = CurrencyFormat.usd.obs;

  static Currency? currency;

  /// Formatos já resolvidos a partir do código, para não reconstruir a tabela
  /// de moedas do `currency_picker` a cada célula de uma lista.
  static final Map<String, CurrencyFormat> _byCode = {};

  static Future<void> updateCurrency(Currency cu) async {
    currency = cu;
    formater.value = formatOf(cu);

    var shared = await SharedPreferences.getInstance();
    shared.setString("currency", jsonEncode(cu));
  }

  /// Converte uma moeda do `currency_picker` no formato do `currency_formatter`.
  static CurrencyFormat formatOf(Currency cu) {
    return CurrencyFormat(
      symbol: cu.symbol,
      symbolSide: cu.symbolOnLeft ? SymbolSide.left : SymbolSide.right,
      // O kwanza vem da tabela com separadores que não são os usados em
      // Angola; esta exceção já existia antes desta funcionalidade.
      thousandSeparator: cu.code == "AOA" ? '.' : cu.thousandsSeparator,
      decimalSeparator: cu.code == "AOA" ? ',' : cu.decimalSeparator,
      symbolSeparator: cu.spaceBetweenAmountAndSymbol ? ' ' : '',
    );
  }

  /// Formato de um código ISO, ou `null` se o código não existir na tabela.
  static CurrencyFormat? formatOfCode(String code) {
    final cached = _byCode[code];
    if (cached != null) return cached;

    final found = CurrencyService().findByCode(code);
    if (found == null) return null;

    return _byCode[code] = formatOf(found);
  }

  /// Resolve o formato a usar para uma lista.
  ///
  /// `null` — ou um código que não exista — cai na moeda do utilizador. Essa
  /// queda é deliberada: uma lista sincronizada de outro dispositivo pode
  /// trazer um código que esta versão da tabela não conhece, e mais vale
  /// mostrar o valor na moeda predefinida do que não mostrar nada.
  static CurrencyFormat resolve(String? currencyCode) {
    if (currencyCode == null) return formater.value;
    return formatOfCode(currencyCode) ?? formater.value;
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

  /// Formata na moeda predefinida do utilizador.
  static String format(double value) {
    return CurrencyFormatter.format(value, formater.value);
  }

  /// Formata na moeda de uma lista.
  ///
  /// É esta que os ecrãs de listas devem usar: passa-se sempre
  /// `list.currencyCode`, e a herança da moeda do utilizador resolve-se aqui.
  static String formatFor(double value, String? currencyCode) {
    return CurrencyFormatter.format(value, resolve(currencyCode));
  }

  /// Símbolo da moeda de uma lista, para o campo de preço do formulário.
  static String symbolFor(String? currencyCode) => resolve(currencyCode).symbol;
}
