# Refatoração de UI — setembro de 2026

Âmbito acordado: **camada visual e de interação**. A gestão de estado
(GetX + Provider + get_it em simultâneo) foi deliberadamente deixada como está
— ver [O que ficou por fazer](#o-que-ficou-por-fazer).

## Bugs corrigidos

Encontrados ao ler o código, não reportados.

### O tema claro usava um `ColorScheme` escuro

```dart
// antes — lib/utils/theme/theme.dart
static ThemeData light = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.dark(...),   // <- escuro, no tema claro
);
```

`ColorScheme.dark()` define `onSurface: Colors.white`. Ou seja, no tema claro
`Theme.of(context).colorScheme.onSurface` era **branco sobre branco**. Foi por
isso que se acumulou `TextStyle(color: Colors.black)` por toda a app: cada ecrã
compensava o tema à mão. Corrigido — ambos os temas saem agora de
`ColorScheme.fromSeed` com o brilho certo.

### A tipografia nunca foi aplicada

Oito sítios pediam `fontFamily: 'Poppins-Medium'`. Nenhuma fonte estava
declarada no `pubspec.yaml`, por isso o Flutter ignorava o pedido em silêncio e
desenhava em Roboto. O pacote `google_fonts` estava nas dependências mas não era
importado por nenhum ficheiro.

Corrigido: Poppins (400/500/600/700) empacotada em `assets/fonts/`,
`google_fonts` removido.

### A categoria selecionada nunca ficava destacada

```dart
// antes — components/create_list.dart
var index = 0.obs;              // RxInt
...
categoryIcon(index == i, ...)   // RxInt == int  ->  sempre false
```

O analisador assinalava isto como `unrelated_type_equality_checks`. Ao criar uma
lista, nenhuma categoria aparecia selecionada. A seleção passou a estado local
do formulário, comparada como `int`.

### `Dismissible` com `UniqueKey()`

```dart
// antes — shopping_list_details.dart
Dismissible(key: UniqueKey(), ...)
```

`UniqueKey()` gera uma chave nova a cada `build`, por isso o Flutter perdia o
rasto do item a meio do gesto de arrastar. Passou a `ValueKey(item.uuid)`.

### `initState` sem `super.initState()`

Em `shopping_list_details.dart` e no (agora removido) `add_item.dart`.

### Mensagens fixas em português

`"Preencha todos os campos"` aparecia como literal mesmo com a app em inglês.
Passou pelas traduções (`fillAllFields`).

## Performance

### Listas deixaram de ser construídas de uma vez

```dart
// antes
SingleChildScrollView(            // o ecrã já estava dentro de outro
  child: Column(
    children: List.generate(lists.length, (i) => ShoppingListCard(lists[i])),
  ),
)
```

Todos os cartões eram construídos, incluindo os que estavam fora do ecrã, e os
dois `SingleChildScrollView` aninhados competiam pelo gesto de scroll.

Agora: `CustomScrollView` + `SliverList.builder`, um scroll por ecrã. Aplica-se
à lista de listas e à lista de itens.

### Layout deixou de depender do tamanho do ecrã

Valores como `height: size.height / 5`, `Positioned(left: size.width * 0.85)`,
`Positioned(left: size.width / 1.42, top: size.width * 0.11)` foram substituídos
por `Row`/`Expanded`/`Wrap`. O layout antigo estava afinado para uma largura de
telemóvel: noutras larguras, e com a fonte do sistema ampliada, os elementos
sobrepunham-se.

## Interação

| Antes | Agora |
|---|---|
| `GestureDetector` nos cartões (sem ripple) | `InkWell` com ripple `InkSparkle` |
| Transição de página genérica | Hero do ícone cartão → detalhe; `PredictiveBackPageTransitionsBuilder` |
| Barra de progresso desenhada com dois `Container` | `AppProgressBar` com valor interpolado |
| Apagar lista sem confirmação | `ConfirmDialog` + snackbar |
| Spinner ao carregar | Esqueletos com a forma dos cartões |
| Sem feedback tátil | Haptics ao marcar, mudar quantidade, apagar e concluir |
| Sem atualização manual | Pull-to-refresh |
| Botões `+`/`−` de 30×25dp | Alvos de 40dp, desativados no mínimo |
| Formulários tapados pelo teclado | Bottom sheets que acompanham o teclado |

## Estrutura

`shopping_list_details.dart` tinha **826 linhas**, com um formulário de 260
linhas lá dentro. Foi dividido:

```
shopping_list_details.dart          ecrã (≈280 linhas)
components/shopping_item_tile.dart  linha de um item
components/item_form_sheet.dart     formulário de adicionar/editar item
components/list_totals.dart         bloco "comprado / em falta" (partilhado)
```

`list_totals.dart` existe porque o cartão e o cabeçalho do detalhe mostravam o
mesmo bloco em duas cópias que já tinham divergido — uma delas tinha quatro
espaços no início do valor para o alinhar.

### Ficheiros removidos

- `lib/pages/shoppinglist/components/add_item.dart` (311 linhas) — código morto,
  nenhum ficheiro o importava. O seu papel é agora de `item_form_sheet.dart`.
- Os dez `lib/utils/theme/*_theme.dart` — substituídos pela composição única.

## Acessibilidade

- Contraste do texto sobre o amarelo da marca: de ~1.7:1 para ~9.4:1.
- Cada cartão anuncia um resumo (`"Compras da semana, 3/8, 37%"`) em vez de
  oito fragmentos soltos.
- Ilustrações decorativas excluídas da árvore de acessibilidade.
- Alvos de toque de 48dp.
- `StaggeredEntrance` respeita a preferência de redução de movimento.

## Verificação

- `flutter analyze`: **0 erros** (221 avisos de estilo, contra 311 antes).
- `flutter build apk --flavor prod --debug`: compila.
- `flutter test`: 3 passam, 13 falham — **exactamente o mesmo resultado no
  commit anterior**, confirmado num worktree separado. As falhas são anteriores
  a esta refatoração (Firebase por inicializar, chamadas de rede reais,
  `sqflite` sem FFI nos testes) e nenhuma toca na camada de UI.
- **Não foi testado em dispositivo.** Nenhuma destas mudanças foi vista a
  correr: o que está verificado é que compila e que o analisador está limpo.

## Correção posterior: a app ficou amarelada

A primeira versão deste trabalho usava o amarelo da marca como *seed* do
`ColorScheme` **e** aquecia as superfícies por cima (`#FFFBF5`, `#FFF8EE`, …).
O Material propaga o matiz do seed a todos os papéis, por isso fundos, cartões,
campos e barra de topo ficaram todos com um véu amarelo. Agravava-o o facto de
`primaryContainer` — que passou a ser um amarelo pálido — ser usado como
superfície grande no drawer e no ecrã de registo, onde antes era branco.

Corrigido:

- *Seed* passou a `Brand.ink`, que gera escalas acromáticas.
- Superfícies fixadas nos valores do tema original.
- `primaryContainer` voltou a neutro (`Colors.white` / `#232224`).
- O tom amarelo diluído do ícone de categoria passou a `accentSoft`, uma cor
  própria em `AppSemanticColors`.
- `surfaceTint` neutro, para a barra de topo não ganhar véu amarelo ao rolar.
- O cartão de resumo do detalhe deixou de ser um bloco em `primaryContainer`.

[`test/theme/color_scheme_test.dart`](../test/theme/color_scheme_test.dart)
fixa a decisão: falha se alguma superfície voltar a ter croma, se o contraste
do texto sobre o amarelo cair abaixo de 4.5:1, ou se o tema claro voltar a ser
construído com brilho escuro.

## O que ficou por fazer

Fora do âmbito acordado, por ordem de valor:

1. **Unificar a gestão de estado.** GetX, Provider e get_it coexistem; o
   `ShoppingListController` é `ChangeNotifier` *e* usa `.obs`, portanto notifica
   duas vezes. Guarda `TextEditingController`s (estado de UI no controlador) e
   refaz a query completa a cada mutação.
2. **Ecrãs não redesenhados:** login, signup, onboarding, drawer, listas
   concluídas, contactos, termos. Recebem o tema novo automaticamente, mas
   mantêm a estrutura antiga e cores literais.
3. **Código morto:** `welcome.dart` não é alcançável a partir de nenhuma rota.
4. **Strings fixas** em `login_controller.dart` e `signup_controller.dart`.
5. **Sem testes de widget.** A pasta `test/` cobre repositórios, não UI.
