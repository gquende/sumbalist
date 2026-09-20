import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/design/design_tokens.dart';

/// Estado vazio reutilizável: ilustração, título, explicação e ação opcional.
///
/// Entra com um fade e uma subida curta para que o ecrã não apareça "de
/// repente" depois de a base de dados responder.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.illustration,
    required this.title,
    this.message,
    this.action,
  });

  /// Caminho do SVG da ilustração.
  final String illustration;

  final String title;
  final String? message;

  /// Botão de ação principal, quando há uma resposta óbvia ao estado vazio.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.xl,
          vertical: Spacing.xxl,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Motion.slow,
          curve: Motion.enter,
          builder: (context, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(
                offset: Offset(0, 16 * (1 - t)), child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // A ilustração é decorativa: fica excluída da árvore de
              // acessibilidade para o leitor de ecrã não a anunciar.
              ExcludeSemantics(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: SvgPicture.asset(illustration),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              if (message != null) ...[
                const SizedBox(height: Spacing.sm),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: Spacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
