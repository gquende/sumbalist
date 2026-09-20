import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/core/configs/app_locale.dart';
import 'package:sumbalist/core/di/dependecy_injection.dart';
import 'package:sumbalist/models/users.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../core/design/design_tokens.dart';
import '../../../mocks/shopping_list_category_mock.dart';
import '../../../models/shopping_list.dart';
import '../../../models/shopping_list_categories.dart';
import '../shopping_list_details.dart';

/// Abre o formulário de criar (ou editar) uma lista de compras.
///
/// Assinatura mantida para não mexer em quem chama.
///
/// Reescrito nesta refatoração:
///
/// * **Bug corrigido:** o destaque da categoria escolhida era decidido por
///   `index == i`, a comparar um `RxInt` com um `int`. Nunca era verdadeiro, por
///   isso nenhuma categoria aparecia selecionada. A seleção passou a estado
///   local do formulário, comparado como `int`.
/// * Era um [Dialog] com altura fixa de 40% do ecrã; com o teclado aberto o
///   conteúdo não cabia. Passou a bottom sheet que acompanha o teclado.
/// * As categorias estavam numa [Row] com `spaceBetween`, que rebentava em
///   ecrãs estreitos. Passaram a [Wrap].
/// * A mensagem de validação estava fixa em português.
Future<void> shoplistForm(BuildContext context, [ShoppingList? item]) async {
  final controller = GetIt.instance.get<ShoppingListController>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ShoplistForm(controller: controller, item: item),
  );
}

class _ShoplistForm extends StatefulWidget {
  const _ShoplistForm({required this.controller, this.item});

  final ShoppingListController controller;
  final ShoppingList? item;

  @override
  State<_ShoplistForm> createState() => _ShoplistFormState();
}

class _ShoplistFormState extends State<_ShoplistForm> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.item?.name ?? '');

  late int _categoryIndex = int.tryParse(widget.item?.categoryUUID ?? '0') ?? 0;

  bool get _isEditing => widget.item != null;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final appLocale = DI.get<AppLocale>();
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(appLocale.strings.fillAllFields),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final existing = widget.item;

    if (existing == null) {
      final shoplist = ShoppingList(
        uuid: const Uuid().v4(),
        userUUID: User.logged?.uuid ?? 'not defined',
        categoryUUID: "$_categoryIndex",
        statusUUID: 'not completed',
        name: name,
        total: 0,
        items: [],
      );

      await widget.controller.createShoppinglist(shoplist);
      if (!mounted) return;

      // Fecha a folha e abre logo a lista criada, para o utilizador poder
      // começar a adicionar itens sem mais um toque.
      Navigator.of(context).pop();
      await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ShoplistDetails(shoppingList: shoplist)),
      );
    } else {
      existing.name = name;
      existing.categoryUUID = "$_categoryIndex";

      await widget.controller.updateShoppinglist(existing);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocale = DI.get<AppLocale>();
    final strings = appLocale.strings;

    return Obx(() {
      final categories = appLocale.locale.value.languageCode == "pt"
          ? shoppingListCategoriesMock
          : shoppingListCategoriesMockEnglish;

      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Spacing.lg,
            Spacing.sm,
            Spacing.lg,
            Spacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEditing ? strings.update : strings.newList,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: Spacing.xl),
              TextField(
                controller: _nameController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: strings.listName,
                  prefixIcon: const Icon(Icons.list_alt_rounded),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              Text(
                strings.category,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Wrap(
                spacing: Spacing.md,
                runSpacing: Spacing.md,
                children: [
                  for (var i = 0; i < categories.length; i++)
                    CategoryOption(
                      category: categories[i],
                      selected: _categoryIndex == i,
                      onTap: () => setState(() => _categoryIndex = i),
                    ),
                ],
              ),
              const SizedBox(height: Spacing.xl),
              FilledButton(
                onPressed: _submit,
                child: Text(_isEditing ? strings.update : strings.add),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Um quadrado de categoria, selecionável.
class CategoryOption extends StatelessWidget {
  const CategoryOption({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final ShoppingListCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHigh;
    final foreground = selected
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: category.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.medium,
        child: AnimatedContainer(
          duration: Motion.fast,
          curve: Motion.standard,
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: Spacing.md),
          decoration: BoxDecoration(
            borderRadius: Radii.medium,
            color: background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, color: foreground),
              const SizedBox(height: Spacing.xs),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
