import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/mixins/localization_mixin.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../core/configs/app_locale.dart';
import '../../core/design/design_tokens.dart';
import '../../core/di/dependecy_injection.dart';
import '../../mocks/shopping_list_category_mock.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../utils/constants/files.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_progress_bar.dart';
import 'components/item_form_sheet.dart';
import 'components/list_totals.dart';
import 'components/shopping_item_tile.dart';
import 'components/shoppinglist_card.dart';

/// Detalhe de uma lista: resumo no topo, itens em baixo.
///
/// Reescrito nesta refatoração. O ficheiro tinha 826 linhas, com a estrutura
/// montada num [Stack] cujos filhos eram posicionados em frações do ecrã
/// (`top: size.height * 0.13`, altura fixa `size.height * 0.8`). O conteúdo
/// sobrepunha-se em ecrãs mais baixos e o formulário de item ocupava 260 dessas
/// linhas dentro do próprio ecrã.
///
/// Agora: [CustomScrollView] com barra que colapsa ao rolar, itens em
/// `SliverList.builder` (só se constrói o que se vê), e o formulário vive em
/// [ItemFormSheet].
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

  @override
  void initState() {
    // A versão anterior não chamava super.initState() — o analisador assinalava
    // `must_call_super`.
    super.initState();

    controller.shoppingList.value = widget.shoppingList;
    controller.getItemsOfShoppingList(widget.shoppingList.uuid).then((items) {
      if (!mounted) return;
      controller.shoppingList.value.items = items;
      controller.shoppingList.refresh();
    });
  }

  /// Marca/desmarca um item e mantém os comprados agrupados no fim.
  Future<void> _toggleDone(ShoppinglistItem item, int index, bool done) async {
    item.isDone = done;
    await controller.updateItem(item);
    if (!mounted) return;

    setState(() => _reorderItem(index));
    controller.shoppingList.refresh();

    final list = controller.shoppingList.value;
    final isComplete = list.getPercentBuyedByItem() == 100.0;

    list.statusUUID = isComplete ? "completed" : "not completed";
    await controller.updateShoppinglist(list);

    if (!mounted || !isComplete) return;

    // Lista terminada: vibração de sucesso e confirmação visível.
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.doneList)),
    );
  }

  Future<void> _changeQty(ShoppinglistItem item, int qty) async {
    item.qty = qty;
    await controller.updateItem(item);
    if (mounted) controller.shoppingList.refresh();
  }

  Future<void> _removeItem(ShoppinglistItem item) async {
    await controller.removeItem(item);
    if (!mounted) return;
    controller.shoppingList.refresh();
    setState(() {});
  }

  Future<void> _openForm({ShoppinglistItem? item}) async {
    final saved = await ItemFormSheet.show(
      context,
      controller: controller,
      listUuid: widget.shoppingList.uuid,
      item: item,
    );
    if (saved && mounted) {
      controller.shoppingList.refresh();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([DI.get<AppLocale>()]),
      builder: (_, __) => Scaffold(
        body: Obx(() {
          final list = controller.shoppingList.value;
          final items = list.items ?? <ShoppinglistItem>[];

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: _Title(list: list),
              ),
              SliverToBoxAdapter(child: _Summary(list: list)),
              if (items.isEmpty)
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
                    0,
                    Spacing.lg,
                    // Espaço para o botão flutuante não tapar o último item.
                    Spacing.xxxl * 2,
                  ),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Spacing.sm),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Dismissible(
                        // A chave era `UniqueKey()`, que muda a cada build: o
                        // Flutter perdia o rasto do item a meio do gesto.
                        key: ValueKey(item.uuid),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          HapticFeedback.mediumImpact();
                          _removeItem(item);
                        },
                        background: const _DeleteBackground(),
                        child: ShoppingItemTile(
                          item: item,
                          onToggleDone: (done) =>
                              _toggleDone(item, index, done),
                          onChangeQty: (qty) => _changeQty(item, qty),
                          onEdit: () => _openForm(item: item),
                        ),
                      );
                    },
                  ),
                ),
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

  /// Move o item para junto dos seus pares: comprados no fim, por comprar no
  /// início. Mantém o comportamento da versão anterior.
  void _reorderItem(int oldIndex) {
    final items = controller.shoppingList.value.items;
    if (items == null || oldIndex >= items.length) return;

    final moved = items.removeAt(oldIndex);
    var newIndex = items.indexWhere((item) => item.isDone);
    if (newIndex == -1) newIndex = items.length;

    items.insert(newIndex, moved);
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
              color: theme.colorScheme.primaryContainer,
            ),
            child: Icon(
              iconCategory[list.categoryUUID] ?? Icons.category,
              size: 20,
              color: theme.colorScheme.onPrimaryContainer,
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

/// Cartão de resumo: totais e progresso da lista.
class _Summary extends StatelessWidget {
  const _Summary({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        Spacing.sm,
        Spacing.lg,
        Spacing.lg,
      ),
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
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
    );
  }
}

/// Fundo vermelho revelado ao arrastar um item para a esquerda.
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
