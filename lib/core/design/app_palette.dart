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
///
/// Escritos por extenso, sem `ColorScheme.fromSeed`.
///
/// Porquê: o `fromSeed` deriva **todos** os papéis do matiz do seed e
/// amplifica-lhes a saturação. Com o amarelo da marca como seed, a app ficou
/// amarelada; ao trocar para o preto-tinta (`#231F20`, cujo vermelho é
/// ligeiramente superior ao verde e ao azul), o Material leu isso como matiz
/// avermelhado e gerou `secondaryContainer: #FFD9E4` — rosa pastel, que foi
/// parar ao menu lateral.
///
/// Sobrepor caso a caso não resolve, porque a lista de papéis que podem ganhar
/// cor é longa e cresce com as versões do Flutter. Escrever a paleta por
/// extenso torna impossível aparecer um matiz que não esteja aqui.
///
/// Os únicos papéis cromáticos são de propósito: o amarelo da marca e os
/// vermelhos de erro.
abstract final class AppColorSchemes {
  static const Color _inkLight = Color(0xFF1C1B1B);
  static const Color _inkDark = Color(0xFFE6E1E1);

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    // Acento da marca.
    primary: Brand.yellow,
    onPrimary: Brand.ink,
    primaryContainer: Colors.white,
    onPrimaryContainer: _inkLight,
    inversePrimary: Brand.yellow,

    // Neutros.
    secondary: Color(0xFF5E5E5E),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE9E9E9),
    onSecondaryContainer: _inkLight,
    tertiary: Color(0xFF6B6B6B),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEFEFEF),
    onTertiaryContainer: _inkLight,

    // Superfícies: branco e cinzentos, como no tema original.
    surface: Colors.white,
    onSurface: _inkLight,
    onSurfaceVariant: Color(0xFF6B6B6B),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFAFAFA),
    surfaceContainer: Color(0xFFF2F2F2),
    surfaceContainerHigh: Color(0xFFE9E9E9),
    surfaceContainerHighest: Color(0xFFE0E0E0),
    surfaceDim: Color(0xFFE0E0E0),
    surfaceBright: Colors.white,
    surfaceTint: Color(0xFF9E9E9E),
    inverseSurface: Color(0xFF2F2F2F),
    onInverseSurface: Color(0xFFF4F4F4),

    outline: Color(0xFF8C8C8C),
    outlineVariant: Color(0xFFDCDCDC),
    shadow: Colors.black,
    scrim: Colors.black,

    // Erro: cromático de propósito — vermelho tem de se ler como vermelho.
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
  );

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    primary: Brand.yellow,
    onPrimary: Brand.ink,
    primaryContainer: Color(0xFF232224),
    onPrimaryContainer: _inkDark,
    inversePrimary: Brand.yellow,

    secondary: Color(0xFFC6C6C6),
    onSecondary: Color(0xFF2E2E2E),
    secondaryContainer: Color(0xFF3A393A),
    onSecondaryContainer: _inkDark,
    tertiary: Color(0xFFB8B8B8),
    onTertiary: Color(0xFF2E2E2E),
    tertiaryContainer: Color(0xFF333233),
    onTertiaryContainer: _inkDark,

    // Valores do tema escuro original.
    surface: Color(0xFF181719),
    onSurface: _inkDark,
    onSurfaceVariant: Color(0xFFA8A4A4),
    surfaceContainerLowest: Color(0xFF121113),
    surfaceContainerLow: Color(0xFF1E1D1F),
    surfaceContainer: Color(0xFF232224),
    surfaceContainerHigh: Color(0xFF2C2C2D),
    surfaceContainerHighest: Color(0xFF343435),
    surfaceDim: Color(0xFF141315),
    surfaceBright: Color(0xFF3A393B),
    surfaceTint: Color(0xFF8A8788),
    inverseSurface: _inkDark,
    onInverseSurface: Color(0xFF2F2E30),

    outline: Color(0xFF8A8788),
    outlineVariant: Color(0xFF3C3A3B),
    shadow: Colors.black,
    scrim: Colors.black,

    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
  );
}
