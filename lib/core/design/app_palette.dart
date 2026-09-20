import 'package:flutter/material.dart';

/// Paleta do SumbaList.
///
/// O amarelo da marca é o *seed* do [ColorScheme]: o Material 3 gera a partir
/// dele as paletas tonais completas para claro e escuro. Sobre esse resultado
/// só se forçam os papéis onde a identidade da marca tem de aparecer exatamente
/// como é — nos restantes, confia-se na geração tonal, que garante contraste.
abstract final class Brand {
  /// Amarelo SumbaList. É a cor de ação: FAB, botões primários, progresso.
  static const Color yellow = Color(0xFFFDB913);

  /// Preto-tinta da marca. Usado como texto *sobre* o amarelo.
  ///
  /// Nota importante: branco sobre [yellow] dá um contraste de ~1.7:1, muito
  /// abaixo do mínimo 4.5:1 do WCAG AA. Este tom dá ~9.4:1.
  static const Color ink = Color(0xFF231F20);

  /// Verde de sucesso — itens comprados, metas atingidas.
  static const Color green = Color(0xFF16AC83);
}

/// Cores com significado que o [ColorScheme] do Material não cobre.
///
/// Registado como [ThemeExtension] para que os widgets leiam sempre via
/// `Theme.of(context)` e o valor certo saia automaticamente em claro/escuro.
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.progressTrack,
  });

  /// Estado concluído: item comprado, lista completa.
  final Color success;

  /// Texto/ícone sobre [success].
  final Color onSuccess;

  /// Fundo suave para realces de sucesso.
  final Color successContainer;

  /// Estado que pede atenção sem ser erro.
  final Color warning;

  /// Calha da barra de progresso.
  final Color progressTrack;

  static const AppSemanticColors light = AppSemanticColors(
    success: Brand.green,
    onSuccess: Colors.white,
    successContainer: Color(0xFFD7F2E9),
    warning: Color(0xFFE08700),
    progressTrack: Color(0xFFECE6DA),
  );

  static const AppSemanticColors dark = AppSemanticColors(
    success: Color(0xFF3ECBA3),
    onSuccess: Color(0xFF00382A),
    successContainer: Color(0xFF14453A),
    warning: Color(0xFFFFB74D),
    progressTrack: Color(0xFF3A3731),
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? progressTrack,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      progressTrack: progressTrack ?? this.progressTrack,
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
    seedColor: Brand.yellow,
    brightness: Brightness.light,
  ).copyWith(
    // O amarelo da marca tem de sair exatamente como é, com tinta escura por
    // cima. A geração tonal do M3 escureceria o amarelo para o tornar legível
    // com texto branco, o que perderia a identidade.
    primary: Brand.yellow,
    onPrimary: Brand.ink,
    primaryContainer: const Color(0xFFFFF0C9),
    onPrimaryContainer: const Color(0xFF3D2E00),
    surface: const Color(0xFFFFFBF5),
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: const Color(0xFFFFF8EE),
    surfaceContainer: const Color(0xFFFCF3E6),
    surfaceContainerHigh: const Color(0xFFF7EDDD),
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: Brand.yellow,
    brightness: Brightness.dark,
  ).copyWith(
    primary: Brand.yellow,
    onPrimary: Brand.ink,
    primaryContainer: const Color(0xFF5B4300),
    onPrimaryContainer: const Color(0xFFFFE9B0),
    surface: const Color(0xFF16150F),
    surfaceContainerLowest: const Color(0xFF100F0A),
    surfaceContainerLow: const Color(0xFF1E1C16),
    surfaceContainer: const Color(0xFF22201A),
    surfaceContainerHigh: const Color(0xFF2D2A22),
  );
}
