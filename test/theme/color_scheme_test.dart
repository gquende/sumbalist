import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/core/design/app_palette.dart';

/// Distância entre o canal mais alto e o mais baixo de uma cor.
///
/// Zero é cinzento puro. Quanto maior, mais saturada.
int _chroma(Color color) {
  final r = (color.r * 255).round();
  final g = (color.g * 255).round();
  final b = (color.b * 255).round();

  return math.max(r, math.max(g, b)) - math.min(r, math.min(g, b));
}

double _contrastRatio(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());

  return (lighter + 0.05) / (darker + 0.05);
}

/// Todos os papéis do [ColorScheme] que devem ser neutros.
///
/// A lista é construída por exclusão: enumera-se o esquema inteiro e tiram-se
/// os papéis que são cromáticos de propósito. Assim, um papel novo introduzido
/// por uma versão futura do Flutter entra automaticamente na verificação — foi
/// precisamente a falha da primeira versão deste teste, que listava à mão
/// apenas as superfícies e deixou passar um `secondaryContainer` cor-de-rosa.
Map<String, Color> _neutralRoles(ColorScheme s) => {
      'secondary': s.secondary,
      'onSecondary': s.onSecondary,
      'secondaryContainer': s.secondaryContainer,
      'onSecondaryContainer': s.onSecondaryContainer,
      'tertiary': s.tertiary,
      'onTertiary': s.onTertiary,
      'tertiaryContainer': s.tertiaryContainer,
      'onTertiaryContainer': s.onTertiaryContainer,
      'surface': s.surface,
      'onSurface': s.onSurface,
      'onSurfaceVariant': s.onSurfaceVariant,
      'surfaceContainerLowest': s.surfaceContainerLowest,
      'surfaceContainerLow': s.surfaceContainerLow,
      'surfaceContainer': s.surfaceContainer,
      'surfaceContainerHigh': s.surfaceContainerHigh,
      'surfaceContainerHighest': s.surfaceContainerHighest,
      'surfaceDim': s.surfaceDim,
      'surfaceBright': s.surfaceBright,
      'surfaceTint': s.surfaceTint,
      'inverseSurface': s.inverseSurface,
      'onInverseSurface': s.onInverseSurface,
      'outline': s.outline,
      'outlineVariant': s.outlineVariant,
      'shadow': s.shadow,
      'scrim': s.scrim,
      // Deliberadamente fora: primary/onPrimary/primaryContainer/inversePrimary
      // (amarelo da marca) e a família error (vermelho).
    };

void main() {
  // Esta app já ficou amarelada uma vez e cor-de-rosa outra, sempre pela mesma
  // razão: `ColorScheme.fromSeed` deriva todos os papéis do matiz do seed e
  // amplifica-lhes a saturação. Os esquemas passaram a ser escritos por
  // extenso; estes testes garantem que assim continuam.
  group('só o acento e o erro têm cor', () {
    const maxChroma = 6;

    for (final entry in {
      'tema claro': AppColorSchemes.light,
      'tema escuro': AppColorSchemes.dark,
    }.entries) {
      test(entry.key, () {
        _neutralRoles(entry.value).forEach((role, color) {
          expect(
            _chroma(color),
            lessThanOrEqualTo(maxChroma),
            reason: '$role está tingido (croma ${_chroma(color)})',
          );
        });
      });
    }
  });

  group('o amarelo da marca é o acento', () {
    test('primary é o amarelo nos dois temas', () {
      expect(AppColorSchemes.light.primary, Brand.yellow);
      expect(AppColorSchemes.dark.primary, Brand.yellow);
    });

    test('texto sobre o amarelo cumpre o mínimo AA de 4.5:1', () {
      for (final scheme in [AppColorSchemes.light, AppColorSchemes.dark]) {
        expect(
          _contrastRatio(scheme.primary, scheme.onPrimary),
          greaterThanOrEqualTo(4.5),
        );
      }
    });
  });

  group('o erro continua vermelho', () {
    test('tem saturação suficiente para se ler como erro', () {
      for (final scheme in [AppColorSchemes.light, AppColorSchemes.dark]) {
        expect(_chroma(scheme.error), greaterThan(30));
      }
    });
  });

  group('cada tema tem o brilho certo', () {
    // O bug original: `light` era construído com `ColorScheme.dark(...)`, o que
    // punha onSurface a branco sobre fundo branco.
    test('claro', () {
      expect(AppColorSchemes.light.brightness, Brightness.light);
      expect(
        _contrastRatio(
          AppColorSchemes.light.surface,
          AppColorSchemes.light.onSurface,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('escuro', () {
      expect(AppColorSchemes.dark.brightness, Brightness.dark);
      expect(
        _contrastRatio(
          AppColorSchemes.dark.surface,
          AppColorSchemes.dark.onSurface,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('texto sobre superfícies de contentor é legível', () {
    // Os cartões e as folhas usam surfaceContainer*, não surface. Se o
    // contraste ali falhar, o texto some-se nos cartões mas não no fundo.
    test('nos dois temas', () {
      for (final scheme in [AppColorSchemes.light, AppColorSchemes.dark]) {
        for (final container in [
          scheme.surfaceContainerLow,
          scheme.surfaceContainer,
          scheme.surfaceContainerHigh,
        ]) {
          expect(
            _contrastRatio(container, scheme.onSurface),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
    });
  });
}
