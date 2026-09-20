import '../../models/shopping_list_item.dart';

/// Regra de ordenação dos itens de uma lista de compras.
///
/// Por comprar em cima, comprados em baixo. Dentro de cada grupo mantém-se a
/// ordem de entrada.
///
/// Está separada do ecrã porque foi exatamente aqui que esteve o erro: a versão
/// anterior mandava um item recém-comprado para o índice do *primeiro* item já
/// comprado, ou seja, para o topo do grupo dos comprados em vez do fim da
/// lista. Como função pura, a regra passa a ser verificável sem correr a app.
abstract final class ItemOrdering {
  /// Índice onde [item] deve entrar, dada a lista **sem ele**.
  ///
  /// - Comprado: fim de tudo.
  /// - Por comprar: imediatamente antes do primeiro comprado, isto é, no fim do
  ///   grupo dos pendentes.
  static int targetIndex(List<ShoppinglistItem> others, ShoppinglistItem item) {
    if (item.isDone) return others.length;

    final firstDone = others.indexWhere((other) => other.isDone);
    return firstDone == -1 ? others.length : firstDone;
  }

  /// Reordena a lista no sítio, agrupando os comprados no fim.
  ///
  /// Usada uma única vez, ao carregar os itens. A partir daí a ordem é mantida
  /// item a item pelos movimentos animados — reordenar em bloco desfaria a
  /// correspondência entre a lista e o que a [SliverAnimatedList] tem no ecrã.
  static void sortByDone(List<ShoppinglistItem> items) {
    items.sort((a, b) {
      if (a.isDone == b.isDone) return 0;
      return a.isDone ? 1 : -1;
    });
  }
}
