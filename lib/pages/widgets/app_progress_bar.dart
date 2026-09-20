import 'package:flutter/material.dart';

import '../../core/design/app_palette.dart';
import '../../core/design/design_tokens.dart';

/// Barra de progresso de uma lista de compras.
///
/// Substitui os dois [Container] empilhados num [Stack] que o cartão usava: o
/// valor era pintado como largura fixa calculada a partir de `MediaQuery`, o
/// que não animava e partia-se em ecrãs largos. Aqui o valor é interpolado
/// com [TweenAnimationBuilder], por isso comprar um item faz a barra *crescer*
/// em vez de saltar.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.percent,
    this.showLabel = true,
  });

  /// Percentagem concluída, de 0 a 100.
  final double percent;

  /// Se mostra a percentagem em texto ao lado da barra.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = (percent / 100).clamp(0.0, 1.0);
    final isComplete = value >= 1.0;
    final barColor =
        isComplete ? context.semantic.success : theme.colorScheme.primary;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: Motion.medium,
      curve: Motion.standard,
      builder: (context, animatedValue, _) {
        return Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: Radii.pill,
                child: LinearProgressIndicator(
                  value: animatedValue,
                  minHeight: Sizes.progressBar,
                  color: barColor,
                  backgroundColor: context.semantic.progressTrack,
                ),
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: Spacing.md),
              // Largura fixa para que a linha não mude de layout quando o
              // número passa de uma para duas ou três casas.
              SizedBox(
                width: 44,
                child: Text(
                  "${(animatedValue * 100).round()}%",
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isComplete
                        ? barColor
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
