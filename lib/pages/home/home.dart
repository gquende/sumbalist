import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/controllers/shopping_list_controller.dart';
import 'package:sumbalist/core/configs/config.dart';
import 'package:sumbalist/mixins/localization_mixin.dart';
import 'package:sumbalist/pages/home/components/drawer/drawer_widget.dart';
import 'package:sumbalist/pages/shoppinglist/components/create_list.dart';
import 'package:sumbalist/pages/shoppinglist/shopping_list_view.dart';

import '../../core/configs/app_locale.dart';
import '../../core/di/dependecy_injection.dart';
import '../../models/users.dart';

/// Ecrã principal.
///
/// Mudanças desta refatoração:
///
/// * O `body` estava envolvido num [SingleChildScrollView] que continha outro
///   lá dentro. Foi removido: quem faz scroll é o ecrã de conteúdo, uma só vez.
/// * A barra de topo passou a alinhar à esquerda, como manda o Material 3, e a
///   saudação deixou de depender de espaços em branco no fim da string para
///   ficar centrada.
/// * O botão flutuante passou a ser [FloatingActionButton.extended] no canto:
///   diz o que faz em vez de ser só um "+".
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with LocalizationMixin {
  final int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    AppConfig.checkVersion(
      context: context,
      label: strings.newVersionTitle,
      message: strings.versionMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ShoppingListController>();

    return ListenableBuilder(
      listenable: Listenable.merge([DI.get<AppLocale>()]),
      builder: (_, __) {
        return Scaffold(
          drawer: const DrawerWidget(),
          appBar: AppBar(
            titleSpacing: 0,
            title: _Greeting(hello: strings.hello),
          ),
          body: SafeArea(child: _page(_currentIndex)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _primaryAction,
            icon: const Icon(Icons.add_rounded),
            label: Text(strings.newList),
          ),
        );
      },
    );
  }

  Widget _page(int page) {
    switch (page) {
      default:
        return const ShoppingListView();
    }
  }

  void _primaryAction() {
    switch (_currentIndex) {
      case 0:
        shoplistForm(context);
    }
  }
}

/// Saudação da barra de topo: "Olá" pequeno por cima do nome do utilizador.
class _Greeting extends StatelessWidget {
  const _Greeting({required this.hello});

  final String hello;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = User.logged;
    final name = [user?.name, user?.surname]
        .where((part) => part != null && part.isNotEmpty)
        .join(' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "👋 $hello",
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (name.isNotEmpty)
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
      ],
    );
  }
}
