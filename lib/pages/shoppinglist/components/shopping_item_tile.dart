import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/design/app_palette.dart';
import '../../../core/design/design_tokens.dart';
import '../../../mixins/localization_mixin.dart';
import '../../../models/shopping_list_item.dart';
import '../../../utils/currency.dart';

/// Linha de um item dentro de uma lista de compras.
///
/// A versão anterior era um [Stack] com três [Positioned] colocados em frações
/// da largura do ecrã (`left: size.width / 1.42`, `left: size.width / 1.16`),
/// o que sobrepunha elementos em qualquer largura que não fosse a do telemóvel
/// onde foi afinado. Aqui é uma [Row] normal: o contador ocupa o espaço que
/// precisa e o nome ocupa o resto.
class ShoppingItemTile extends StatelessWidget {
  const ShoppingItemTile({
    super.key,
    required this.item,
    required this.onToggleDone,
    required this.onChangeQty,
    required this.onEdit,
  });

  final ShoppinglistItem item;

  /// Chamado quando o item é marcado/desmarcado como comprado.
  final ValueChanged<bool> onToggleDone;

  /// Chamado com a nova quantidade.
  final ValueChanged<int> onChangeQty;

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = item.isDone;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: done
          ? context.semantic.successContainer
          : theme.colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          child: Row(
            children: [
              Checkbox(
                value: done,
                onChanged: (value) {
                  if (value == null) return;
                  // Feedback tátil: confirma o toque sem obrigar a olhar.
                  HapticFeedback.selectionClick();
                  onToggleDone(value);
                },
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // O risco sobre o nome aparece gradualmente em vez de
                    // surgir de repente ao marcar o item.
                    AnimatedDefaultTextStyle(
                      duration: Motion.fast,
                      curve: Motion.standard,
                      style: (theme.textTheme.titleMedium ?? const TextStyle())
                          .copyWith(
                        decoration: done ? TextDecoration.lineThrough : null,
                        decorationColor: theme.colorScheme.onSurfaceVariant,
                        color: done
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                      child: Text(
                        item.itemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.description.isNotEmpty)
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      AppCurrencyFormat.format(item.totalPrice()),
                      style: theme.textTheme.labelMedium?.merge(
                        TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              _QtyStepper(
                qty: item.qty,
                onChanged: onChangeQty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contador de quantidade: menos, valor, mais.
///
/// Os botões têm o alvo de toque mínimo de 48dp — antes eram caixas de 30x25
/// desenhadas com [Container], demasiado pequenas para acertar com o polegar.
class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.qty, required this.onChanged});

  final int qty;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: Radii.pill,
        color: theme.colorScheme.surfaceContainerHigh,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove_rounded,
            // Desativado em 1: a quantidade mínima de um item é um.
            onPressed: qty > 1 ? () => onChanged(qty - 1) : null,
            tooltip: appStrings.decreaseQuantity,
          ),
          // Largura fixa para que passar de 9 para 10 não mexa no layout.
          SizedBox(
            width: 28,
            child: Text(
              "$qty",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.merge(
                const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onPressed: () => onChanged(qty + 1),
            tooltip: appStrings.increaseQuantity,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 18),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints(
        minWidth: Sizes.minTapTarget - 8,
        minHeight: Sizes.minTapTarget - 8,
      ),
      onPressed: onPressed == null
          ? null
          : () {
              HapticFeedback.lightImpact();
              onPressed!();
            },
    );
  }
}
