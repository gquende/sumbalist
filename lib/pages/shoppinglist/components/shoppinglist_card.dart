import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/mocks/shopping_list_category_mock.dart';

import '../../../controllers/currency_controller.dart';
import '../../../controllers/shopping_list_controller.dart';
import '../../../core/configs/app_locale.dart';
import '../../../core/design/app_palette.dart';
import '../../../core/design/design_tokens.dart';
import '../../../core/di/dependecy_injection.dart';
import '../../../mixins/localization_mixin.dart';
import '../../../models/shopping_list.dart';
import '../../../utils/currency.dart';
import '../../widgets/app_progress_bar.dart';
import '../../widgets/confirm_dialog.dart';
import '../shopping_list_details.dart';
import 'create_list.dart';
import 'list_totals.dart';

/// Cartão de uma lista de compras.
///
/// Reescrito nesta refatoração. O que mudou em relação à versão anterior:
///
/// * Altura deixou de ser `MediaQuery.height / 5` — o cartão cresce com o seu
///   conteúdo, por isso não se parte com fontes ampliadas nem em tablets.
/// * O menu deixou de ser posicionado com `Positioned(left: width * 0.85)`;
///   está numa [Row], que se adapta a qualquer largura.
/// * `GestureDetector` deu lugar a [InkWell]: o toque passa a ter ripple.
/// * O ícone de categoria é um [Hero] partilhado com o ecrã de detalhe.
/// * Apagar passa a pedir confirmação.
class ShoppingListCard extends StatelessWidget {
  const ShoppingListCard(this.shoppinglist, {super.key});

  final ShoppingList shoppinglist;

  /// Tag do [Hero] do ícone. Partilhada com o ecrã de detalhe.
  static String heroTag(ShoppingList list) => 'list-icon-${list.uuid}';

  @override
  Widget build(BuildContext context) {
    // Redesenha quando a moeda muda (o total é formatado com ela).
    context.watch<CurrencyController>();

    return ListenableBuilder(
      listenable: Listenable.merge([DI.get<AppLocale>()]),
      builder: (_, __) => _CardBody(shoppinglist),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody(this.list);

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final percent = list.getPercentBuyedByItem();
    final bought = list.calculateTotalItemBuyed();
    final total = list.items?.length ?? 0;

    // Sem este resumo, o leitor de ecrã anuncia oito fragmentos soltos
    // ("Comprado", "1.200", "(3)", …) em vez de descrever a lista.
    return Semantics(
      container: true,
      button: true,
      label: '${list.name}, $bought/$total, ${percent.round()}%',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_) => ShoplistDetails(shoppingList: list)),
          ),
          child: Padding(
            padding: Spacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(list: list),
                const SizedBox(height: Spacing.lg),
                ListTotals(list: list),
                const SizedBox(height: Spacing.md),
                // O texto da percentagem já está no resumo semântico do cartão,
                // por isso aqui a barra é puramente visual.
                ExcludeSemantics(child: AppProgressBar(percent: percent)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha de topo: ícone da categoria, nome, total e menu de acções.
class _Header extends StatelessWidget {
  const _Header({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: ShoppingListCard.heroTag(list),
          child: Container(
            width: Sizes.categoryIcon,
            height: Sizes.categoryIcon,
            decoration: BoxDecoration(
              borderRadius: Radii.medium,
              color: context.semantic.accentSoft,
            ),
            child: Icon(
              iconCategory[list.categoryUUID] ?? Icons.category,
              size: 24,
              color: context.semantic.onAccentSoft,
            ),
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                list.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                AppCurrencyFormat.format(list.calculateTotal()),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _ListMenu(list: list),
      ],
    );
  }
}

/// Menu de acções do cartão (editar / apagar).
class _ListMenu extends StatelessWidget {
  const _ListMenu({required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = GetIt.instance.get<ShoppingListController>();

    return PopupMenuButton<_ListAction>(
      icon: const Icon(Icons.more_vert_rounded),
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      position: PopupMenuPosition.under,
      onSelected: (action) async {
        switch (action) {
          case _ListAction.edit:
            shoplistForm(context, list);
          case _ListAction.delete:
            final confirmed = await ConfirmDialog.show(
              context,
              title: appStrings.deleteListTitle,
              message: appStrings.deleteListMessage(list.name),
              confirmLabel: appStrings.delete,
              cancelLabel: appStrings.cancel,
            );
            if (!confirmed || !context.mounted) return;

            await controller.deleteShoppinglist(list);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(appStrings.listDeleted)),
            );
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _ListAction.edit,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.edit_outlined),
            title: Text(appStrings.edit),
          ),
        ),
        PopupMenuItem(
          value: _ListAction.delete,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.delete_outline_rounded,
                color: theme.colorScheme.error),
            title: Text(
              appStrings.delete,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}

enum _ListAction { edit, delete }
