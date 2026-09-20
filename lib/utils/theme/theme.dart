import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/design/app_palette.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/design_tokens.dart';

/// Tema da aplicação.
///
/// A API pública (`light`, `darkMode`, `isDarkMode`, `setDarkMode`,
/// `loadThemeMode`) é a mesma de antes — só a construção mudou.
///
/// O que estava errado e aqui se corrige: o tema **claro** era construído com
/// `ColorScheme.dark(...)`. Como consequência, todos os papéis `on*` vinham
/// calculados para fundo escuro, e cada ecrã compensava isso com
/// `TextStyle(color: Colors.black)` à mão. Ao usar o esquema certo, o Material
/// passa a resolver as cores de texto e ícone sozinho.
class AppTheme {
  AppTheme._();

  static var isDarkMode = false.obs;

  static final ThemeData light =
      _build(AppColorSchemes.light, AppSemanticColors.light);

  static final ThemeData darkMode =
      _build(AppColorSchemes.dark, AppSemanticColors.dark);

  static Future<void> setDarkMode(bool value) async {
    isDarkMode.value = value;
    var shared = await SharedPreferences.getInstance();
    await shared.setBool("themeMode", value);
  }

  static Future<bool> loadThemeMode() async {
    var shared = await SharedPreferences.getInstance();
    isDarkMode.value = shared.getBool("themeMode") ?? false;

    return isDarkMode.value;
  }

  /// Monta um [ThemeData] completo a partir de um esquema de cor.
  ///
  /// Ambos os temas passam por aqui: não há um caminho para claro e outro para
  /// escuro, o que elimina a classe de bugs em que só um dos dois é atualizado.
  static ThemeData _build(ColorScheme scheme, AppSemanticColors semantic) {
    final textTheme = AppTypography.textTheme;
    final isDark = scheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: AppTypography.family,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[semantic],

      // Ripple do Material 3: propaga-se a partir do ponto tocado em vez de
      // preencher o componente todo.
      splashFactory: InkSparkle.splashFactory,

      // Transições de página com direção, em vez do fade genérico do Android.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        // Ao rolar, a barra ganha um tom de superfície em vez de uma sombra
        // dura — é o sinal de elevação do Material 3.
        scrolledUnderElevation: 3,
        backgroundColor: scheme.surface,
        surfaceTintColor: scheme.surfaceTint,
        centerTitle: false,
        iconTheme: IconThemeData(color: scheme.onSurface, size: 24),
        actionsIconTheme: IconThemeData(color: scheme.onSurface, size: 24),
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: Radii.large),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: scheme.onSurface.withValues(alpha: 0.12),
          disabledForegroundColor: scheme.onSurface.withValues(alpha: 0.38),
          minimumSize: const Size.fromHeight(Sizes.minTapTarget + 4),
          padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(Sizes.minTapTarget),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          minimumSize: const Size.fromHeight(Sizes.minTapTarget),
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.onSurface,
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 3,
        highlightElevation: 1,
        shape: const RoundedRectangleBorder(borderRadius: Radii.large),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        errorMaxLines: 3,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.lg,
          vertical: Spacing.lg,
        ),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        labelStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        hintStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        floatingLabelStyle:
            textTheme.bodySmall?.copyWith(color: scheme.onSurface),
        errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
        border: const OutlineInputBorder(
          borderRadius: Radii.medium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: Radii.medium,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.medium,
          borderSide: BorderSide(width: 2, color: scheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.medium,
          borderSide: BorderSide(width: 1, color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.medium,
          borderSide: BorderSide(width: 2, color: scheme.error),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(borderRadius: Radii.small),
        side: BorderSide(width: 2, color: scheme.outline),
        checkColor: WidgetStatePropertyAll(scheme.onPrimary),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return Colors.transparent;
        }),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primary,
        disabledColor: scheme.onSurface.withValues(alpha: 0.12),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle:
            textTheme.labelMedium?.copyWith(color: scheme.onPrimary),
        checkmarkColor: scheme.onPrimary,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm,
        ),
        shape: const RoundedRectangleBorder(borderRadius: Radii.small),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: scheme.surfaceContainerLow,
        modalBackgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        dragHandleColor: scheme.outlineVariant,
        constraints: const BoxConstraints(minWidth: double.infinity),
        shape: const RoundedRectangleBorder(borderRadius: Radii.sheet),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle:
            textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isDark ? scheme.surfaceContainerHigh : scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? scheme.onSurface : scheme.onInverseSurface,
        ),
        actionTextColor: scheme.primary,
        insetPadding: const EdgeInsets.all(Spacing.lg),
        shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle:
            textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
        contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 3,
        textStyle: textTheme.bodyMedium,
        shape: const RoundedRectangleBorder(borderRadius: Radii.medium),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: semantic.progressTrack,
        linearMinHeight: Sizes.progressBar,
      ),

      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),

      iconTheme: IconThemeData(color: scheme.onSurface),
    );
  }
}
