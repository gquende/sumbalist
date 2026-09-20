import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/core/design/app_palette.dart';

/// Distância entre o canal mais alto e o mais baixo de uma cor.
///
/// Zero é cinzento puro. Quanto maior, mais saturada — e, no caso desta app,
/// mais amarelada.
int _chroma(Color color) {
  final r = (color.r * 255).round();
  final g = (color.g * 255).round();
  final b = (color.b * 255).round();

  return math.max(r, math.max(g, b)) - math.min(r, math.min(g, b));
}

/// Luminância relativa segundo a WCAG.
double _luminance(Color color) => color.computeLuminance();

double _contrastRatio(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);

  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  // Uma versão anterior desta refatoração usava o amarelo da marca como seed do
  // ColorScheme e aquecia as superfícies por cima, o que tingia a app inteira.
  // Estes testes fixam a decisão: superfícies neutras, amarelo só como acento.
  group('superfícies são neutras', () {
    const maxChroma = 6;

    test('tema claro', () {
      final scheme = AppColorSchemes.light;

      for (final entry in <String, Color>{
        'surface': scheme.surface,
        'surfaceContainerLowest': scheme.surfaceContainerLowest,
        'surfaceContainerLow': scheme.surfaceContainerLow,
        'surfaceContainer': scheme.surfaceContainer,
        'surfaceContainerHigh': scheme.surfaceContainerHigh,
        'surfaceContainerHighest': scheme.surfaceContainerHighest,
        'primaryContainer': scheme.primaryContainer,
        'outlineVariant': scheme.outlineVariant,
      }.entries) {
        expect(
          _chroma(entry.value),
          lessThanOrEqualTo(maxChroma),
          reason: '${entry.key} está tingido (croma ${_chroma(entry.value)})',
        );
      }
    });

    test('tema escuro', () {
      final scheme = AppColorSchemes.dark;

      for (final entry in <String, Color>{
        'surface': scheme.surface,
        'surfaceContainerLowest': scheme.surfaceContainerLowest,
        'surfaceContainerLow': scheme.surfaceContainerLow,
        'surfaceContainer': scheme.surfaceContainer,
        'surfaceContainerHigh': scheme.surfaceContainerHigh,
        'surfaceContainerHighest': scheme.surfaceContainerHighest,
        'primaryContainer': scheme.primaryContainer,
      }.entries) {
        expect(
          _chroma(entry.value),
          lessThanOrEqualTo(maxChroma),
          reason: '${entry.key} está tingido (croma ${_chroma(entry.value)})',
        );
      }
    });
  });

  group('o amarelo da marca é acento', () {
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

  group('o tema claro é mesmo claro', () {
    // O bug original: `light` era construído com `ColorScheme.dark(...)`, o que
    // punha onSurface a branco sobre fundo branco.
    test('brightness e contraste', () {
      final scheme = AppColorSchemes.light;

      expect(scheme.brightness, Brightness.light);
      expect(
        _contrastRatio(scheme.surface, scheme.onSurface),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('o tema escuro também', () {
      final scheme = AppColorSchemes.dark;

      expect(scheme.brightness, Brightness.dark);
      expect(
        _contrastRatio(scheme.surface, scheme.onSurface),
        greaterThanOrEqualTo(4.5),
      );
    });
  });
}
