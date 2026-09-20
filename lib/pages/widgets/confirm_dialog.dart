import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/design/design_tokens.dart';

/// Diálogo de confirmação para acções destrutivas.
///
/// Antes desta refatoração, tocar em "Apagar" no menu de um cartão removia a
/// lista imediatamente, sem confirmação nem forma de recuperar. Agora a acção
/// destrutiva pede confirmação e é apresentada na cor de erro do tema.
///
/// Devolve `true` se o utilizador confirmar, `false` ou `null` caso contrário.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.isDestructive = true,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Pinta a acção de confirmação com a cor de erro.
  final bool isDestructive;

  /// Abre o diálogo e devolve a decisão do utilizador.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    bool isDestructive = true,
  }) async {
    // Vibração curta: sinaliza que o que vem a seguir merece atenção.
    unawaited(HapticFeedback.mediumImpact());

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = isDestructive ? scheme.error : scheme.primary;

    return AlertDialog(
      icon: Icon(
        isDestructive
            ? Icons.delete_outline_rounded
            : Icons.help_outline_rounded,
        color: accent,
        size: 28,
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      actionsPadding: const EdgeInsets.fromLTRB(
        Spacing.lg,
        0,
        Spacing.lg,
        Spacing.lg,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: isDestructive ? scheme.onError : scheme.onPrimary,
            minimumSize: const Size(0, Sizes.minTapTarget),
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
