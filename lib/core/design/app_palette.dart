import 'package:flutter/material.dart';

/// Paleta do SumbaList.
///
/// **Superfícies neutras, amarelo só como acento.**
///
/// Uma primeira versão desta refatoração usava o amarelo da marca como *seed*
/// de todo o `ColorScheme` e ainda aquecia as superfícies por cima. O resultado
/// tingia a app inteira de amarelo — fundos, cartões, campos, barra de topo.
/// O *seed* passou a ser o preto-tinta da marca, que gera escalas
/// praticamente neutras, e as superfícies voltaram aos valores do tema
/// anterior: branco e cinzentos no claro, quase-preto no escuro.
///
/// O amarelo aparece onde é informação: botão flutuante, botões primários,
/// barra de progresso, categoria selecionada e o quadrado do ícone da
/// categoria.
abstract final class Brand {
  /// Amarelo SumbaList. É a cor de ação, não a cor de fundo.
  static const Color yellow = Color(0xFFFDB913);

  /// Preto-tinta da marca. Texto *sobre* o amarelo, e seed dos neutros.
  ///
  /// Branco sobre [yellow] dá um contraste de ~1.7:1, muito abaixo do mínimo
  /// de 4.5:1 do WCAG AA. Este tom dá ~9.4:1.
  static const Color ink = Color(0xFF231F20);

  /// Verde de sucesso — itens comprados, metas atingidas.
  static const Color green = Color(0xFF16AC83);
}

/// Cores com significado que o [ColorScheme] do Material não cobre.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.progressTrack,
    required this.accentSoft,
    required this.onAccentSoft,
  });

  /// Estado concluído: item comprado, lista completa.
  final Color success;

  /// Texto/ícone sobre [success].
  final Color onSuccess;

  /// Fundo suave para realces de sucesso.
  final Color successContainer;

  /// Estado que pede atenção sem ser erro.
  final Color warning;

  /// Calha da barra de progresso. Cinzento neutro: o que se vê é o preenchido.
  final Color progressTrack;

  /// Amarelo muito diluído, para o quadrado do ícone de categoria.
  ///
  /// Existe como cor própria porque `primaryContainer` é usado como superfície
  /// grande noutros ecrãs (drawer, registo). Tingir esse papel de amarelo
  /// pintava metade da app; este acento só se aplica onde é pedido.
  final Color accentSoft;

  /// Ícone sobre [accentSoft].
  final Color onAccentSoft;

  static const AppSemanticColors light = AppSemanticColors(
    success: Brand.green,
    onSuccess: Colors.white,
    successContainer: Color(0xFFEDF7F4),
    warning: Color(0xFFE08700),
    progressTrack: Color(0xFFE6E6E6),
    accentSoft: Color(0xFFFFF3D1),
    onAccentSoft: Color(0xFF6B5200),
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF3ECBA3),
    onSuccess: Color(0xFF00382A),
    successContainer: Color(0xFF1F2A28),
    warning: Color(0xFFFFB74D),
    progressTrack: Color(0xFF3A3A3B),
    accentSoft: Color(0xFF3B2F0B),
    onAccentSoft: Color(0xFFFFD780),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? progressTrack,
    Color? accentSoft,
    Color? onAccentSoft,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      progressTrack: progressTrack ?? this.progressTrack,
      accentSoft: accentSoft ?? this.accentSoft,
      onAccentSoft: onAccentSoft ?? this.onAccentSoft,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      progressTrack: Color.lerp(progressTrack, other.progressTrack, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      onAccentSoft: Color.lerp(onAccentSoft, other.onAccentSoft, t)!,
    );
  }
}

/// Atalho de leitura: `context.semantic.success`.
extension SemanticColorsX on BuildContext {
  AppSemanticColors get semantic =>
      Theme.of(this).extension<AppSemanticColors>() ?? AppSemanticColors.light;
}

/// Os dois [ColorScheme] da aplicação.
abstract final class AppColorSchemes {
  static final ColorScheme light = ColorScheme.fromSeed(
    // Seed neutro: gera cinzentos, não amarelos.
    seedColor: Brand.ink,
    brightness: Brightness.light,
  ).copyWith(
    primary: Brand.yellow,
    onPrimary: Brand.ink,

    // Neutro, como no tema anterior (era `Colors.white`). Este papel é usado
    // como superfície grande no drawer e no ecrã de registo.
    primaryContainer: Colors.white,
    onPrimaryContainer: const Color(0xFF1C1B1B),

    // Superfícies do tema anterior: branco e cinzentos.
    surface: Colors.white,
    onSurface: const Color(0xFF1C1B1B),
    onSurfaceVariant: const Color(0xFF6B6B6B),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: const Color(0xFFFAFAFA),
    surfaceContainer: const Color(0xFFF2F2F2),
    surfaceContainerHigh: const Color(0xFFE9E9E9),
    surfaceContainerHighest: const Color(0xFFE0E0E0),
    outline: const Color(0xFF8C8C8C),
    outlineVariant: const Color(0xFFDCDCDC),

    // Tinta de elevação neutra: sem isto, uma barra de topo com conteúdo por
    // baixo ganhava um véu amarelo ao rolar.
    surfaceTint: const Color(0xFF9E9E9E),
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: Brand.ink,
    brightness: Brightness.dark,
  ).copyWith(
    primary: Brand.yellow,
    onPrimary: Brand.ink,
    // Valor do tema escuro anterior.
    primaryContainer: const Color(0xFF232224),
    onPrimaryContainer: const Color(0xFFE6E1E1),

    // Valores do tema escuro anterior.
    surface: const Color(0xFF181719),
    onSurface: const Color(0xFFE6E1E1),
    onSurfaceVariant: const Color(0xFFA8A4A4),
    surfaceContainerLowest: const Color(0xFF121113),
    surfaceContainerLow: const Color(0xFF1E1D1F),
    surfaceContainer: const Color(0xFF232224),
    surfaceContainerHigh: const Color(0xFF2C2C2D),
    surfaceContainerHighest: const Color(0xFF343435),
    outline: const Color(0xFF8A8788),
    outlineVariant: const Color(0xFF3C3A3B),
    surfaceTint: const Color(0xFF8A8788),
  );
}
