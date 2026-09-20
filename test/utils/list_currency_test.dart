import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/utils/currency.dart';

/// Põe o kwanza como moeda predefinida do utilizador, como na app.
void _defaultToKwanza() {
  final kwanza = CurrencyService().findByCode('AOA')!;
  AppCurrencyFormat.currency = kwanza;
  AppCurrencyFormat.formater.value = AppCurrencyFormat.formatOf(kwanza);
}

void main() {
  setUp(_defaultToKwanza);

  group('uma lista sem moeda herda a do utilizador', () {
    test('resolve devolve o formato predefinido', () {
      expect(
        AppCurrencyFormat.resolve(null).symbol,
        AppCurrencyFormat.formater.value.symbol,
      );
    });

    test('a herança acompanha mudanças da predefinição', () {
      final antes = AppCurrencyFormat.formatFor(1000, null);

      final euro = CurrencyService().findByCode('EUR')!;
      AppCurrencyFormat.currency = euro;
      AppCurrencyFormat.formater.value = AppCurrencyFormat.formatOf(euro);

      final depois = AppCurrencyFormat.formatFor(1000, null);

      expect(
        depois,
        isNot(antes),
        reason: 'uma lista que herda tem de mudar quando a predefinição muda',
      );
    });
  });

  group('uma lista com moeda própria não herda', () {
    test('usa a sua e ignora a predefinida', () {
      final comMoeda = AppCurrencyFormat.formatFor(1000, 'EUR');
      final herdada = AppCurrencyFormat.formatFor(1000, null);

      expect(comMoeda, isNot(herdada));
      expect(comMoeda, contains('€'));
    });

    test('mudar a predefinição não lhe toca', () {
      final antes = AppCurrencyFormat.formatFor(1000, 'EUR');

      final dolar = CurrencyService().findByCode('USD')!;
      AppCurrencyFormat.currency = dolar;
      AppCurrencyFormat.formater.value = AppCurrencyFormat.formatOf(dolar);

      expect(AppCurrencyFormat.formatFor(1000, 'EUR'), antes);
    });

    test('o símbolo do campo de preço segue a moeda da lista', () {
      expect(
        AppCurrencyFormat.symbolFor('EUR'),
        isNot(AppCurrencyFormat.symbolFor(null)),
      );
    });
  });

  group('um código desconhecido cai na predefinida', () {
    // Uma lista sincronizada de outro dispositivo pode trazer um código que
    // esta versão da tabela de moedas não conhece. Mais vale mostrar o valor na
    // moeda do utilizador do que não mostrar nada.
    test('resolve não rebenta', () {
      expect(
        AppCurrencyFormat.resolve('ZZZ').symbol,
        AppCurrencyFormat.formater.value.symbol,
      );
    });

    test('formatFor devolve o mesmo que herdar', () {
      expect(
        AppCurrencyFormat.formatFor(1000, 'ZZZ'),
        AppCurrencyFormat.formatFor(1000, null),
      );
    });
  });
}
