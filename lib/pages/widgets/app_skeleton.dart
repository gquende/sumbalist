import 'package:flutter/material.dart';

import '../../core/design/design_tokens.dart';

/// Placeholder animado para conteúdo que ainda está a carregar.
///
/// Serve para substituir o spinner centrado: mostrando já a *forma* do que vem
/// a seguir, a transição para o conteúdo real não desloca o layout.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = Radii.medium,
  });

  final double height;
  final double width;
  final BorderRadius borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHigh;
    final highlight = scheme.surfaceContainerLowest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              // O brilho atravessa o bloco da esquerda para a direita.
              begin: Alignment(-1 - 2 * _controller.value, 0),
              end: Alignment(1 - 2 * _controller.value, 0),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}

/// Esqueleto com a forma de um cartão de lista de compras.
class ShoppingListCardSkeleton extends StatelessWidget {
  const ShoppingListCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Spacing.card,
      decoration: BoxDecoration(
        borderRadius: Radii.large,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppSkeleton(
                height: Sizes.categoryIcon,
                width: Sizes.categoryIcon,
                borderRadius: Radii.medium,
              ),
              SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSkeleton(height: 18, width: 160),
                    SizedBox(height: Spacing.sm),
                    AppSkeleton(height: 14, width: 90),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.lg),
          AppSkeleton(height: Sizes.progressBar, borderRadius: Radii.pill),
        ],
      ),
    );
  }
}
