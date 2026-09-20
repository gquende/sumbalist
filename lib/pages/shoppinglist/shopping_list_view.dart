import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../core/configs/app_locale.dart';
import '../../core/design/design_tokens.dart';
import '../../core/di/dependecy_injection.dart';
import '../../mixins/localization_mixin.dart';
import '../../utils/constants/files.dart';
import '../widgets/app_empty_state.dart';
import '../widgets/app_skeleton.dart';
import '../widgets/staggered_entrance.dart';
import 'components/create_list.dart';
import 'components/shoppinglist_card.dart';

/// Ecrã com as listas de compras por concluir.
///
/// Reescrito nesta refatoração:
///
/// * A lista era um `Column(children: List.generate(...))` dentro de dois
///   [SingleChildScrollView] aninhados. Todos os cartões eram construídos de
///   uma vez, mesmo os que estavam fora do ecrã, e os dois scrolls competiam
///   pelo gesto. Passou a [CustomScrollView] com `SliverList.builder`, que só
///   constrói o que está visível.
/// * Enquanto carrega, mostra esqueletos com a forma dos cartões em vez de um
///   spinner — a passagem para o conteúdo real não desloca o layout.
/// * Ganhou *pull-to-refresh*.
class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView>
    with LocalizationMixin {
  final ShoppingListController controller =
      GetIt.instance.get<ShoppingListController>();

  Future<void> _refresh() =>
      controller.getAllShoppingListNotCompleted(status: "not completed");

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([DI.get<AppLocale>()]),
      builder: (_, __) => RefreshIndicator(
        onRefresh: _refresh,
        child: Obx(() {
          final lists = controller.allShoppingList;
          final isLoading = controller.isLoading.value;

          return CustomScrollView(
            // Mantém o gesto de puxar disponível mesmo quando o conteúdo não
            // chega para encher o ecrã.
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (lists.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.lg,
                    Spacing.md,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      strings.myList,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
              if (isLoading && lists.isEmpty)
                const _LoadingSkeletons()
              else if (lists.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    illustration: AppAssets.NO_DATA_IMAGE,
                    title: strings.whatAreYouGoingToBuyToday,
                    message: strings.createAListAndFollowUp,
                    action: FilledButton.icon(
                      onPressed: () => shoplistForm(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(strings.createFirstList),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    Spacing.lg,
                    0,
                    Spacing.lg,
                    // Espaço para o FAB não tapar o último cartão.
                    Spacing.xxxl * 2,
                  ),
                  sliver: SliverList.separated(
                    itemCount: lists.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Spacing.md),
                    itemBuilder: (context, index) {
                      final list = lists[index];
                      return StaggeredEntrance(
                        index: index,
                        // A chave amarra o estado do cartão à lista que mostra,
                        // para que reordenar não reaproveite o widget errado.
                        child: ShoppingListCard(list, key: ValueKey(list.uuid)),
                      );
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

/// Três cartões-fantasma enquanto a base de dados responde.
class _LoadingSkeletons extends StatelessWidget {
  const _LoadingSkeletons();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
        itemBuilder: (_, __) => const ShoppingListCardSkeleton(),
      ),
    );
  }
}
