import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/models/shopping_list_item.dart';
import 'package:sumbalist/pages/shoppinglist/item_ordering.dart';

ShoppinglistItem _item(String name, {bool done = false}) => ShoppinglistItem(
      uuid: name,
      isDone: done,
      listUUID: 'lista',
      itemName: name,
      description: '',
      qty: 1,
      price: 100,
      priority: 1,
    );

List<String> _names(List<ShoppinglistItem> items) =>
    items.map((item) => item.itemName).toList();

/// Simula o que o ecrã faz ao marcar/desmarcar: tira o item, muda-lhe o estado
/// e volta a pô-lo no índice que a regra indicar.
void _toggle(List<ShoppinglistItem> items, String name, {required bool done}) {
  final item = items.firstWhere((candidate) => candidate.itemName == name);

  items.remove(item);
  item.isDone = done;
  items.insert(ItemOrdering.targetIndex(items, item), item);
}

void main() {
  group('marcar manda o item para o fim da lista', () {
    test('com a lista toda por comprar', () {
      final items = [_item('arroz'), _item('feijão'), _item('óleo')];

      _toggle(items, 'arroz', done: true);

      expect(_names(items), ['feijão', 'óleo', 'arroz']);
    });

    test('vai para depois dos que já estavam comprados, não para antes', () {
      // Este é o caso que a versão anterior errava: mandava o item para o topo
      // do grupo dos comprados em vez do fim da lista.
      final items = [
        _item('arroz'),
        _item('feijão'),
        _item('óleo', done: true),
        _item('sal', done: true),
      ];

      _toggle(items, 'arroz', done: true);

      expect(_names(items), ['feijão', 'óleo', 'sal', 'arroz']);
      expect(items.last.itemName, 'arroz');
    });

    test('marcar o último pendente deixa a lista toda comprada', () {
      final items = [_item('arroz'), _item('feijão', done: true)];

      _toggle(items, 'arroz', done: true);

      expect(_names(items), ['feijão', 'arroz']);
      expect(items.every((item) => item.isDone), isTrue);
    });
  });

  group('desmarcar traz o item de volta para cima', () {
    test('para o fim do grupo dos pendentes', () {
      final items = [
        _item('arroz'),
        _item('feijão'),
        _item('óleo', done: true),
        _item('sal', done: true),
      ];

      _toggle(items, 'sal', done: false);

      expect(_names(items), ['arroz', 'feijão', 'sal', 'óleo']);
    });

    test('para o início quando não há pendentes', () {
      final items = [_item('arroz', done: true), _item('feijão', done: true)];

      _toggle(items, 'feijão', done: false);

      expect(_names(items), ['feijão', 'arroz']);
    });
  });

  group('os comprados ficam sempre depois dos pendentes', () {
    test('depois de uma sequência de marcações e desmarcações', () {
      final items = [
        _item('arroz'),
        _item('feijão'),
        _item('óleo'),
        _item('sal'),
      ];

      _toggle(items, 'feijão', done: true);
      _toggle(items, 'arroz', done: true);
      _toggle(items, 'feijão', done: false);
      _toggle(items, 'sal', done: true);

      final firstDone = items.indexWhere((item) => item.isDone);
      final lastPending = items.lastIndexWhere((item) => !item.isDone);

      expect(
        lastPending,
        lessThan(firstDone),
        reason: 'um item comprado apareceu antes de um por comprar: '
            '${_names(items)}',
      );
    });
  });

  group('sortByDone agrupa ao carregar', () {
    test('mantém a ordem dentro de cada grupo', () {
      final items = [
        _item('arroz', done: true),
        _item('feijão'),
        _item('óleo', done: true),
        _item('sal'),
      ];

      ItemOrdering.sortByDone(items);

      expect(_names(items), ['feijão', 'sal', 'arroz', 'óleo']);
    });
  });
}
