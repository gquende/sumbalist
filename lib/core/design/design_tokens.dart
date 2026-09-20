import 'package:flutter/widgets.dart';

/// Tokens de design do SumbaList.
///
/// Fonte única de verdade para espaçamento, raios e motion. Se um widget
/// precisa de um valor que não existe aqui, falta um token — não se escreve
/// o número à mão.

/// Escala de espaçamento, em múltiplos de 4dp.
abstract final class Spacing {
  /// 4dp — separação entre elementos que se leem como um só (ícone + label).
  static const double xs = 4;

  /// 8dp — espaço interno apertado.
  static const double sm = 8;

  /// 12dp — separação entre linhas dentro de um cartão.
  static const double md = 12;

  /// 16dp — margem lateral padrão do ecrã e padding interno de cartões.
  static const double lg = 16;

  /// 24dp — separação entre blocos distintos.
  static const double xl = 24;

  /// 32dp — separação entre secções.
  static const double xxl = 32;

  /// 48dp — respiro de estados vazios.
  static const double xxxl = 48;

  /// Margem lateral do conteúdo de ecrã.
  static const EdgeInsets screenH = EdgeInsets.symmetric(horizontal: lg);

  /// Padding interno padrão de um cartão.
  static const EdgeInsets card = EdgeInsets.all(lg);
}

/// Raios de canto. Quanto maior o elemento, maior o raio.
abstract final class Radii {
  /// 8dp — chips, badges, elementos pequenos.
  static const BorderRadius small = BorderRadius.all(Radius.circular(8));

  /// 12dp — campos de texto e botões.
  static const BorderRadius medium = BorderRadius.all(Radius.circular(12));

  /// 20dp — cartões.
  static const BorderRadius large = BorderRadius.all(Radius.circular(20));

  /// 28dp — bottom sheets e diálogos (raio M3 para superfícies grandes).
  static const BorderRadius sheet =
      BorderRadius.vertical(top: Radius.circular(28));

  /// Totalmente arredondado — barras de progresso e pills.
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

/// Durações e curvas de animação.
///
/// Os valores seguem as recomendações de motion do Material 3: transições
/// curtas para feedback direto, médias para mudanças de estado visíveis,
/// longas apenas para entradas de ecrã.
abstract final class Motion {
  /// 120ms — feedback imediato (ripple, mudança de cor de um ícone).
  static const Duration instant = Duration(milliseconds: 120);

  /// 200ms — mudanças de estado dentro de um componente.
  static const Duration fast = Duration(milliseconds: 200);

  /// 320ms — transições de página e expansões.
  static const Duration medium = Duration(milliseconds: 320);

  /// 500ms — animações de entrada escalonadas em listas.
  static const Duration slow = Duration(milliseconds: 500);

  /// Curva padrão: acelera pouco, desacelera muito. Dá a sensação de
  /// "assentar" em vez de parar de repente.
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Para elementos que entram no ecrã.
  static const Curve enter = Curves.easeOutCubic;

  /// Para elementos que saem do ecrã.
  static const Curve exit = Curves.easeInCubic;

  /// Atraso entre itens consecutivos numa entrada escalonada.
  static const Duration stagger = Duration(milliseconds: 40);
}

/// Alturas fixas de componentes, para manter ritmo vertical consistente.
abstract final class Sizes {
  /// Altura mínima de um alvo de toque (guideline de acessibilidade).
  static const double minTapTarget = 48;

  /// Lado do quadrado do ícone de categoria num cartão.
  static const double categoryIcon = 48;

  /// Espessura da barra de progresso de uma lista.
  static const double progressBar = 10;
}
