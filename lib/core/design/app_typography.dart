import 'package:flutter/material.dart';

/// Tipografia do SumbaList.
///
/// Uma única [TextTheme] serve os dois temas. As cores ficam deliberadamente a
/// `null`: o Material resolve-as a partir do [ColorScheme] (`onSurface` e
/// `onSurfaceVariant`), o que faz com que claro e escuro fiquem certos sem
/// duplicar a escala — era exatamente isso que obrigava o código antigo a ter
/// `lightTextTheme` e `darkTextTheme` iguais exceto no preto/branco.
///
/// A família Poppins está empacotada em `assets/fonts` (ver `pubspec.yaml`).
/// Antes desta refatoração o código pedia `fontFamily: 'Poppins-Medium'`, que
/// nunca foi declarado em lado nenhum — a app corria em Roboto sem que isso
/// fosse evidente.
abstract final class AppTypography {
  static const String family = 'Poppins';

  /// Escala tipográfica alinhada com o type scale do Material 3.
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: family,
      fontSize: 40,
      fontWeight: FontWeight.w700,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: family,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.2,
      letterSpacing: -0.4,
    ),
    headlineLarge: TextStyle(
      fontFamily: family,
      fontSize: 28,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -0.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: family,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.3,
      letterSpacing: -0.2,
    ),
    headlineSmall: TextStyle(
      fontFamily: family,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    titleLarge: TextStyle(
      fontFamily: family,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    titleMedium: TextStyle(
      fontFamily: family,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontFamily: family,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: family,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontFamily: family,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.4,
    ),
    labelLarge: TextStyle(
      fontFamily: family,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: family,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0.2,
    ),
    labelSmall: TextStyle(
      fontFamily: family,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.2,
      letterSpacing: 0.3,
    ),
  );

  /// Estilo para valores monetários.
  ///
  /// `FontFeature.tabularFigures` fixa a largura dos dígitos, para que um total
  /// que muda de 9,00 para 10,00 não faça o resto da linha saltar.
  static const TextStyle money = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );
}
