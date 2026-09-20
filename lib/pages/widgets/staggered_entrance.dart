import 'package:flutter/material.dart';

import '../../core/design/design_tokens.dart';

/// Faz um item de lista entrar com fade e uma subida curta, atrasado em função
/// da sua posição.
///
/// O efeito dá à lista a sensação de se "assentar" em vez de aparecer de uma
/// só vez. O atraso é limitado para que uma lista longa não deixe os últimos
/// itens à espera — passado o sexto, todos entram juntos.
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  static const int _maxStaggered = 6;

  @override
  Widget build(BuildContext context) {
    // Respeita a preferência de sistema de redução de movimento.
    if (MediaQuery.disableAnimationsOf(context)) return child;

    final delay = Motion.stagger * (index.clamp(0, _maxStaggered));

    return _DelayedFadeSlide(delay: delay, child: child);
  }
}

class _DelayedFadeSlide extends StatefulWidget {
  const _DelayedFadeSlide({required this.delay, required this.child});

  final Duration delay;
  final Widget child;

  @override
  State<_DelayedFadeSlide> createState() => _DelayedFadeSlideState();
}

class _DelayedFadeSlideState extends State<_DelayedFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.medium,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Motion.enter);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.06),
          end: Offset.zero,
        ).animate(curved),
        child: widget.child,
      ),
    );
  }
}
