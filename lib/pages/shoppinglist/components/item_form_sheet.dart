import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../core/design/design_tokens.dart';
import '../../../mixins/localization_mixin.dart';
import '../../../models/shopping_list_item.dart';
import '../../../utils/currency.dart';

/// Formulário de adicionar/editar um item, apresentado como bottom sheet.
///
/// Substitui o método `bottomSheet()` de 260 linhas que vivia dentro do ecrã de
/// detalhe. Três mudanças de fundo:
///
/// * Cada campo era um [Container] pintado à mão com um [TextField] lá dentro e
///   a decoração repetida por extenso quatro vezes. Agora usam o
///   `inputDecorationTheme`, por isso mudam todos de uma vez a partir do tema.
/// * Passou a abrir com `showModalBottomSheet(isScrollControlled: true)` e a
///   reservar espaço para o teclado — antes, com o teclado aberto, o botão de
///   guardar ficava tapado.
/// * As larguras deixaram de ser `size.width / 2.5`.
class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({
    super.key,
    required this.controller,
    required this.listUuid,
    required this.currencyCode,
    this.item,
  });

  final ShoppingListController controller;
  final String listUuid;

  /// Moeda da lista, para o campo de preço aparecer na moeda certa.
  final String? currencyCode;

  /// `null` para criar um item novo; caso contrário, o item a editar.
  final ShoppinglistItem? item;

  /// Abre o formulário e devolve o item gravado, ou `null` se foi cancelado.
  ///
  /// O formulário persiste mas **não** insere o item na lista em memória: quem
  /// chama é que decide a posição e a animação de entrada. Sem isto, um item
  /// novo aparecia no fim da lista, depois dos já comprados.
  static Future<ShoppinglistItem?> show(
    BuildContext context, {
    required ShoppingListController controller,
    required String listUuid,
    required String? currencyCode,
    ShoppinglistItem? item,
  }) {
    return showModalBottomSheet<ShoppinglistItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ItemFormSheet(
        controller: controller,
        listUuid: listUuid,
        currencyCode: currencyCode,
        item: item,
      ),
    );
  }

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> with LocalizationMixin {
  late final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter.currency(
    symbol: AppCurrencyFormat.symbolFor(widget.currencyCode),
  );

  ShoppingListController get _controller => widget.controller;

  bool get _isEditing => widget.item != null;

  @override
  void initState() {
    super.initState();

    final item = widget.item;

    if (item == null) {
      // Os `TextEditingController` vivem no controlador partilhado, por isso
      // guardam o que lá ficou. Sem esta limpeza, abrir "adicionar" logo a
      // seguir a cancelar uma edição trazia os dados do item anterior.
      _controller.resetData();
    } else {
      _controller.nameFieldController.text = item.itemName;
      _controller.descriptionController.text = item.description;
      _controller.qtyController.text = "${item.qty}";
      _controller.priority = item.priority;
    }

    // O preço **tem** de entrar pelo formatador, não por `.text`.
    //
    // `CurrencyTextInputFormatter` guarda o valor num campo interno que só é
    // atualizado quando o utilizador escreve — os `inputFormatters` do Flutter
    // não correm em atribuições programáticas. Como `_save()` lê o preço de
    // `getUnformattedValue()`, uma atribuição direta deixava esse valor a zero:
    // quem editasse um item mexendo só na quantidade gravava o preço a zero.
    //
    // `formatDouble` faz as duas coisas — devolve o texto formatado para o
    // campo e inicializa o valor interno. Ver
    // `test/pages/item_price_formatter_test.dart`.
    _controller.priceController.text =
        _currencyFormatter.formatDouble(item?.price ?? 0);
  }

  Future<void> _save() async {
    if (!_controller.validateForm(context)) return;

    final price = double.parse("${_currencyFormatter.getUnformattedValue()}");
    final qty = int.tryParse(_controller.qtyController.text) ?? 1;
    final existing = widget.item;

    if (existing == null) {
      final item = ShoppinglistItem(
        uuid: const Uuid().v4(),
        isDone: false,
        listUUID: widget.listUuid,
        itemName: _controller.nameFieldController.text,
        description: _controller.descriptionController.text,
        qty: qty,
        price: price,
        priority: _controller.priority,
      );

      final result = await _controller.addItem(item);
      if (result != 0) {
        _controller.shoppingList.value.statusUUID = 'not completed';
        await _controller.updateShoppinglist(_controller.shoppingList.value);
      }

      if (mounted) Navigator.of(context).pop(item);
      return;
    } else {
      existing.itemName = _controller.nameFieldController.text;
      existing.description = _controller.descriptionController.text;
      existing.qty = qty;
      existing.price = price;
      existing.priority = _controller.priority;
      await _controller.updateItem(existing);
    }

    if (mounted) Navigator.of(context).pop(existing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      // Empurra o conteúdo acima do teclado enquanto ele abre.
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
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
              _isEditing ? strings.update : strings.add,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: Spacing.xl),
            TextField(
              controller: _controller.nameFieldController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              autofocus: !_isEditing,
              decoration: InputDecoration(
                labelText: strings.name,
                prefixIcon: const Icon(Icons.label_outline_rounded),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller.priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    inputFormatters: [_currencyFormatter],
                    decoration: InputDecoration(
                      labelText: strings.price,
                      prefixIcon: const Icon(Icons.payments_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                SizedBox(
                  // Largura suficiente para quantidades de três dígitos; o
                  // preço fica com o resto da linha.
                  width: 120,
                  child: TextField(
                    controller: _controller.qtyController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: strings.quantity,
                      prefixIcon: const Icon(Icons.tag_rounded),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            TextField(
              controller: _controller.descriptionController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _save(),
              decoration: InputDecoration(
                labelText: strings.description,
                prefixIcon: const Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            FilledButton(
              onPressed: _save,
              child: Text(_isEditing ? strings.update : strings.add),
            ),
          ],
        ),
      ),
    );
  }
}
