import 'package:flutter/material.dart';

import '../../../core/design/design_tokens.dart';
import '../../../mixins/localization_mixin.dart';
import '../../../models/shopping_list.dart';
import '../../../utils/currency.dart';

/// Resumo "comprado / em falta" de uma lista.
///
/// Extraído para aqui porque o cartão da lista e o cabeçalho do ecrã de detalhe
/// mostravam exactamente o mesmo bloco, com as duas cópias a divergirem ao
/// longo do tempo (uma tinha `"    "` no início do valor para o alinhar).
class ListTotals extends StatelessWidget {
  const ListTotals({super.key, required this.list});

  final ShoppingList list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TotalBlock(
            label: appStrings.completed,
            value: AppCurrencyFormat.format(list.calculateTotalBuyed()),
            count: list.calculateTotalItemBuyed(),
            valueColor: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: Spacing.md),
        Expanded(
          child: TotalBlock(
            label: appStrings.remaining,
            value: AppCurrencyFormat.format(
              list.calculateTotal() - list.calculateTotalBuyed(),
            ),
            count: list.calculateTotalItemPending(),
            valueColor: theme.colorScheme.onSurfaceVariant,
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

/// Um valor monetário com etiqueta e contagem de itens.
class TotalBlock extends StatelessWidget {
  const TotalBlock({
    super.key,
    required this.label,
    required this.value,
    required this.count,
    required this.valueColor,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final int count;
  final Color valueColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // Dígitos de largura fixa: o valor muda sem empurrar o resto da linha.
          style: theme.textTheme.titleMedium?.merge(
            TextStyle(
              color: valueColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Text(
          "($count)",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
