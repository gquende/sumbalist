import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/mixins/localization_mixin.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../core/configs/app_locale.dart';
import '../../core/design/app_palette.dart';
import '../../core/design/design_tokens.dart';
import '../../core/di/dependecy_injection.dart';
import '../../mocks/shopping_list_category_mock.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../utils/constants/files.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_progress_bar.dart';
import '../widgets/app_skeleton.dart';
import 'item_ordering.dart';
import 'components/item_form_sheet.dart';
import 'components/list_totals.dart';
import 'components/shopping_item_tile.dart';
import 'components/shoppinglist_card.dart';

/// Detalhe de uma lista: resumo no topo, itens em baixo.
///
/// ## Ordenação e movimento
///
/// Os itens por comprar ficam em cima e os comprados em baixo. Marcar um item
/// manda-o para o **fim** da lista; desmarcá-lo trá-lo de volta para o fim do
/// grupo dos pendentes. A passagem é animada: o item encolhe e desliza na
/// direção para onde vai, e reaparece do lado de onde veio.
///
/// A lista é uma [SliverAnimatedList] em vez de uma `SliverList`, porque só
/// esta sabe animar entradas e saídas. A consequência é que a posição dos itens
/// deixa de poder ser alterada por reconstrução: toda a mutação tem de passar
/// por `insertItem`/`removeItem`, senão a lista e o que está no ecrã
/// dessincronizam. É por isso que [ItemFormSheet] devolve o item em vez de o
/// inserir por si.
///
/// Antes desta versão, `_reorderItem` inseria o item marcado no índice do
/// primeiro item já comprado — ou seja, no **topo** do grupo dos comprados, e
/// não no fim da lista. A troca era instantânea, sem transição.
class ShoplistDetails extends StatefulWidget {
  const ShoplistDetails({super.key, required this.shoppingList});

  final ShoppingList shoppingList;

  @override
  State<ShoplistDetails> createState() => _ShoplistDetailsState();
}

class _ShoplistDetailsState extends State<ShoplistDetails>
    with LocalizationMixin {
  final ShoppingListController controller =
      GetIt.instance.get<ShoppingListController>();

  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();

  /// Se a lista já saiu do topo. Só serve para revelar a linha por baixo do
  /// cabeçalho fixo, e por isso é um [ValueNotifier] em vez de `setState`: não
  /// vale a pena reconstruir o ecrã inteiro a cada pixel de scroll.
  final ValueNotifier<bool> _scrolled = ValueNotifier<bool>(false);

  /// Duração de uma passagem de item entre grupos.
  static const Duration _moveDuration = Duration(milliseconds: 340);

  bool _loaded = false;

  /// A lista que está no ecrã. É a mesma instância que o controlador usa para
  /// calcular totais, por isso as duas vistas nunca divergem.
  List<ShoppinglistItem> get _items =>
      controller.shoppingList.value.items ??= <ShoppinglistItem>[];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final scrolled =
          _scrollController.hasClients && _scrollController.offset > 0;
      if (scrolled != _scrolled.value) _scrolled.value = scrolled;
    });

    controller.shoppingList.value = widget.shoppingList;
    controller.getItemsOfShoppingList(widget.shoppingList.uuid).then((items) {
      if (!mounted) return;

      ItemOrdering.sortByDone(items);

      controller.shoppingList.value.items = items;
      controller.shoppingList.refresh();
      setState(() => _loaded = true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrolled.dispose();
    super.dispose();
  }

  int _targetIndex(ShoppinglistItem item) =>
      ItemOrdering.targetIndex(_items, item);

  /// Tira o item da posição atual e volta a pô-lo no sítio certo, com animação
  /// de saída e de entrada.
  void _animateToPosition(ShoppinglistItem item) {
    final from = _items.indexOf(item);
    if (from == -1) return;

    _items.removeAt(from);
    final to = _targetIndex(item);

    if (from == to) {
      // Já estava no sítio: repõe sem animar, para não piscar.
      _items.insert(to, item);
      return;
    }

    _listKey.currentState?.removeItem(
      from,
      (context, animation) => _leavingRow(item, animation),
      duration: _moveDuration,
    );

    _items.insert(to, item);
    _listKey.currentState?.insertItem(to, duration: _moveDuration);
  }

  Future<void> _toggleDone(ShoppinglistItem item, bool done) async {
    HapticFeedback.selectionClick();

    // O movimento acontece já. Guardar na base de dados e no Firebase demora o
    // suficiente para a animação parecer um salto atrasado se esperássemos.
    setState(() {
      item.isDone = done;
      _animateToPosition(item);
    });
    controller.shoppingList.refresh();

    await controller.updateItem(item);
    if (!mounted) return;

    final list = controller.shoppingList.value;
    final isComplete = list.getPercentBuyedByItem() == 100.0;

    list.statusUUID = isComplete ? "completed" : "not completed";
    await controller.updateShoppinglist(list);

    if (!mounted || !isComplete) return;

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.doneList)),
    );
  }

  Future<void> _changeQty(ShoppinglistItem item, int qty) async {
    setState(() => item.qty = qty);
    controller.shoppingList.refresh();

    await controller.updateItem(item);
  }

  void _dismissItem(ShoppinglistItem item) {
    final index = _items.indexOf(item);
    if (index == -1) return;

    _items.removeAt(index);

    // O [Dismissible] já fechou o espaço, por isso a remoção da lista animada é
    // instantânea — animá-la outra vez fazia o resto da lista saltar.
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => const SizedBox.shrink(),
      duration: Duration.zero,
    );

    controller.shoppingList.refresh();
    setState(() {});

    controller.removeItem(item);
  }

  Future<void> _openForm({ShoppinglistItem? item}) async {
    final saved = await ItemFormSheet.show(
      context,
      controller: controller,
      listUuid: widget.shoppingList.uuid,
      currencyCode: controller.shoppingList.value.currencyCode,
      item: item,
    );

    if (saved == null || !mounted) return;

    if (_items.contains(saved)) {
      // Edição: pode ter mudado o preço ou a quantidade, mas não o grupo.
      setState(() {});
    } else {
      final to = _targetIndex(saved);
      setState(() => _items.insert(to, saved));
      _listKey.currentState?.insertItem(to, duration: _moveDuration);
    }

    controller.shoppingList.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([DI.get<AppLocale>()]),
      builder: (_, __) => Scaffold(
        appBar: AppBar(
            title: Obx(() => _Title(list: controller.shoppingList.value))),
        body: Obx(() {
          final list = controller.shoppingList.value;

          // O resumo fica fora do [CustomScrollView], por isso não rola. Não é
          // um SliverPersistentHeader de propósito: esse exige altura fixa em
          // pixels, e a altura deste cartão depende do tamanho de letra do
          // sistema — voltaria a partir-se com a fonte ampliada.
          return Column(
            children: [
              _PinnedSummary(list: list, scrolled: _scrolled),
              Expanded(child: _itemsScrollView()),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openForm,
          icon: const Icon(Icons.add_rounded),
          label: Text(strings.add),
        ),
      ),
    );
  }

  /// A parte que rola: só os itens.
  Widget _itemsScrollView() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (!_loaded)
          const _LoadingItems()
        else if (_items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyState(
              illustration: AppAssets.ADD_NOTE_IMAGE,
              title: strings.noItemListToBuy,
              message: strings.addItemAndBuy,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              Spacing.lg,
              Spacing.md,
              Spacing.lg,
              // Espaço para o botão flutuante não tapar o último item.
              Spacing.xxxl * 2,
            ),
            sliver: SliverAnimatedList(
              key: _listKey,
              initialItemCount: _items.length,
              itemBuilder: (context, index, animation) {
                if (index >= _items.length) {
                  return const SizedBox.shrink();
                }
                return _arrivingRow(_items[index], animation);
              },
            ),
          ),
      ],
    );
  }

  /// Item a chegar à posição nova.
  ///
  /// Entra pelo lado de onde veio: um item comprado desceu, portanto assoma por
  /// cima; um desmarcado subiu, portanto assoma por baixo. É esse detalhe que
  /// faz a transição ler-se como um movimento e não como dois acasos.
  Widget _arrivingRow(ShoppinglistItem item, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: Motion.standard);
    final fromAbove = item.isDone;

    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, fromAbove ? -0.3 : 0.3),
            end: Offset.zero,
          ).animate(curved),
          child: _row(item),
        ),
      ),
    );
  }

  /// Item a sair da posição antiga: encolhe, desvanece e escorrega na direção
  /// para onde vai.
  Widget _leavingRow(ShoppinglistItem item, Animation<double> animation) {
    final curved = CurvedAnimation(parent: animation, curve: Motion.standard);
    final movingDown = item.isDone;

    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: curved,
        child: SlideTransition(
          // A animação corre de 1 para 0, por isso `begin` é o destino.
          position: Tween<Offset>(
            begin: Offset(0, movingDown ? 0.3 : -0.3),
            end: Offset.zero,
          ).animate(curved),
          child: IgnorePointer(child: _row(item)),
        ),
      ),
    );
  }

  Widget _row(ShoppinglistItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.sm),
      child: Dismissible(
        key: ValueKey(item.uuid),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          HapticFeedback.mediumImpact();
          _dismissItem(item);
        },
        background: const _DeleteBackground(),
        child: ShoppingItemTile(
          item: item,
          currencyCode: controller.shoppingList.value.currencyCode,
          onToggleDone: (done) => _toggleDone(item, done),
          onChangeQty: (qty) => _changeQty(item, qty),
          onEdit: () => _openForm(item: item),
        ),
      ),
    );
  }
}

/// Esqueletos enquanto os itens vêm da base de dados.
class _LoadingItems extends StatelessWidget {
  const _LoadingItems();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.md, Spacing.lg, 0),
      sliver: SliverList.separated(
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.sm),
        itemBuilder: (_, __) => const AppSkeleton(height: 72),
      ),
    );
  }
}

/// Título da barra: ícone da categoria (continuação do [Hero] do cartão) e nome.
class _Title extends StatelessWidget {
  const _Title({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Hero(
          tag: ShoppingListCard.heroTag(list),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: Radii.small,
              color: context.semantic.accentSoft,
            ),
            child: Icon(
              iconCategory[list.categoryUUID] ?? Icons.category,
              size: 20,
              color: context.semantic.onAccentSoft,
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Text(
            list.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

/// Cabeçalho fixo: totais e progresso da lista.
///
/// Fica acima da área que rola, por isso os números de referência estão sempre
/// à vista enquanto se percorre os itens.
///
/// A linha por baixo só aparece depois de a lista sair do topo. Sem ela, um
/// item a passar por trás do cabeçalho não tem onde "desaparecer" e o cartão
/// parece colado ao conteúdo; com ela sempre visível, pesa quando não é
/// preciso. A largura da borda é sempre 1 — só a cor é que anima — para o
/// aparecimento não deslocar o layout por um pixel.
class _PinnedSummary extends StatelessWidget {
  const _PinnedSummary({required this.list, required this.scrolled});

  final ShoppingList list;
  final ValueListenable<bool> scrolled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ValueListenableBuilder<bool>(
      valueListenable: scrolled,
      builder: (context, hasScrolled, child) {
        return AnimatedContainer(
          duration: Motion.fast,
          curve: Motion.standard,
          decoration: BoxDecoration(
            color: scheme.surface,
            border: Border(
              bottom: BorderSide(
                color: hasScrolled ? scheme.outlineVariant : Colors.transparent,
              ),
            ),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Spacing.lg,
          Spacing.sm,
          Spacing.lg,
          Spacing.lg,
        ),
        child: Card(
          color: scheme.surfaceContainer,
          child: Padding(
            padding: Spacing.card,
            child: Column(
              children: [
                ListTotals(list: list),
                const SizedBox(height: Spacing.lg),
                AppProgressBar(percent: list.getPercentBuyedByItem()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Fundo revelado ao arrastar um item para a esquerda.
class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
      decoration: BoxDecoration(
        borderRadius: Radii.large,
        color: scheme.errorContainer,
      ),
      child: Icon(Icons.delete_outline_rounded, color: scheme.onErrorContainer),
    );
  }
}
