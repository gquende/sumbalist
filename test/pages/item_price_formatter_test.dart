import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

/// O formulário de item constrói o formatador assim.
CurrencyTextInputFormatter _formatter() =>
    CurrencyTextInputFormatter.currency(symbol: 'AOA');

void main() {
  // Contexto: ao editar um item mexendo só na quantidade, o preço era gravado
  // a zero.
  //
  // A causa é este formatador. Ele guarda o valor num campo interno que só é
  // atualizado quando o *utilizador escreve* no campo — os `inputFormatters` do
  // Flutter não correm em atribuições programáticas. O formulário fazia
  // `priceController.text = "${item.price}"` e depois lia
  // `getUnformattedValue()`, que nunca tinha visto nada.
  group('o valor interno do formatador', () {
    test('começa a zero, mesmo que o campo mostre um preço', () {
      final formatter = _formatter();

      // Exatamente o que uma atribuição direta a `.text` deixava para trás.
      expect(
        formatter.getUnformattedValue(),
        0,
        reason: 'se isto deixar de ser zero, o bug original mudou de natureza',
      );
    });

    test('formatDouble() inicializa-o', () {
      final formatter = _formatter();

      formatter.formatDouble(1500);

      expect(formatter.getUnformattedValue(), 1500);
    });

    test('formatDouble() devolve o texto já formatado para o campo', () {
      final formatter = _formatter();

      final text = formatter.formatDouble(1500);

      expect(text, isNotEmpty);
      expect(text, contains('1'));
    });
  });

  group('o preço sobrevive à ida e volta', () {
    test('valores redondos', () {
      for (final price in <double>[0, 1, 50, 1500, 999999]) {
        final formatter = _formatter();

        formatter.formatDouble(price);

        expect(
          formatter.getUnformattedValue(),
          closeTo(price, 0.001),
          reason: 'preço $price não sobreviveu',
        );
      }
    });

    test('cêntimos não se perdem', () {
      final formatter = _formatter();

      formatter.formatDouble(1234.56);

      // O código anterior fazia `item.price.round()` ao encher o campo, o que
      // já deitava fora os cêntimos antes mesmo de guardar.
      expect(formatter.getUnformattedValue(), closeTo(1234.56, 0.001));
    });
  });
}
