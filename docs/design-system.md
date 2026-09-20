# Sistema de design

Guia de referência para escrever UI no SumbaList. Se estás a escrever um widget
novo, lê a secção **Regras** no fim — é curta e evita as três coisas que mais
partiram esta app.

## Onde está o quê

| Ficheiro | Responsabilidade |
|---|---|
| [`lib/core/design/design_tokens.dart`](../lib/core/design/design_tokens.dart) | `Spacing`, `Radii`, `Motion`, `Sizes` |
| [`lib/core/design/app_palette.dart`](../lib/core/design/app_palette.dart) | Cor da marca, os dois `ColorScheme`, `AppSemanticColors` |
| [`lib/core/design/app_typography.dart`](../lib/core/design/app_typography.dart) | Escala tipográfica (Poppins) |
| [`lib/utils/theme/theme.dart`](../lib/utils/theme/theme.dart) | Composição: monta o `ThemeData` a partir dos anteriores |

Antes havia dez ficheiros `lib/utils/theme/*_theme.dart`, um por componente,
cada um com uma variante clara e outra escura escritas à mão. Foram substituídos
por uma única função `_build(ColorScheme, AppSemanticColors)` por onde passam os
dois temas — não há um caminho para claro e outro para escuro que possam
divergir.

## Cor

**Superfícies neutras, amarelo só como acento.** Os dois `ColorScheme` são
escritos por extenso, sem `ColorScheme.fromSeed`.

```dart
static const ColorScheme light = ColorScheme(
  brightness: Brightness.light,
  primary: Brand.yellow,          // acento
  onPrimary: Brand.ink,           // tinta escura, não branco
  secondaryContainer: Color(0xFFE9E9E9),   // neutro, escrito à mão
  surface: Colors.white,
  ...
);
```

**Não se usa `fromSeed` aqui, e a razão importa.** Esse construtor deriva
*todos* os papéis do matiz do seed e amplifica-lhes a saturação. Esta app pagou
isso duas vezes:

1. Com o amarelo da marca como seed, superfícies, contornos e tinta de elevação
   saíram todos amarelados.
2. Ao trocar para o preto-tinta `#231F20` — cujo canal vermelho é ligeiramente
   superior ao verde e ao azul — o Material leu um matiz avermelhado e gerou
   `secondaryContainer: #FFD9E4`. Rosa pastel, que foi parar ao menu lateral.

Sobrepor papéis caso a caso não chega: a lista dos que podem ganhar cor é longa
e cresce com as versões do Flutter. A paleta por extenso torna impossível
aparecer um matiz que não esteja lá escrito.

[`test/theme/color_scheme_test.dart`](../test/theme/color_scheme_test.dart)
verifica *todos* os papéis por exclusão — enumera o esquema e tira os que são
cromáticos de propósito (a família `primary`, amarela, e a família `error`,
vermelha). Um papel novo numa versão futura do Flutter entra automaticamente na
verificação.

O amarelo aparece onde é informação: botão flutuante, botões primários, barra de
progresso e categoria selecionada. Para o quadrado do ícone de categoria há um
tom diluído próprio, `context.semantic.accentSoft` — não se usa
`primaryContainer` para isso, porque esse papel é superfície grande noutros
ecrãs (drawer, registo) e tingi-lo pintava metade da app.

**Porquê tinta escura sobre o amarelo:** branco sobre `#FDB913` dá um contraste
de cerca de 1.7:1, muito abaixo do mínimo de 4.5:1 do WCAG AA. `Brand.ink`
(`#231F20`) dá cerca de 9.4:1. O código anterior usava
`foregroundColor: Colors.white` nos botões primários.

Cores que o `ColorScheme` não cobre (sucesso, aviso, calha de progresso) vivem
em `AppSemanticColors`, registado como `ThemeExtension`:

```dart
context.semantic.success
context.semantic.progressTrack
context.semantic.accentSoft
```

## Tipografia

Poppins, empacotada em `assets/fonts/` e declarada no `pubspec.yaml`.

Antes, oito sítios pediam `fontFamily: 'Poppins-Medium'` — uma família que nunca
foi declarada em lado nenhum. A app corria em Roboto sem que isso fosse
evidente. O pacote `google_fonts` estava nas dependências mas não era usado por
nenhum ficheiro; foi removido.

A `TextTheme` é **uma só** para os dois temas. As cores ficam a `null` de
propósito: o Material resolve-as a partir do `ColorScheme`. É por isso que não
há uma `lightTextTheme` e uma `darkTextTheme` iguais exceto no preto/branco.

Para valores monetários usa-se `FontFeature.tabularFigures()`, para que um total
que passa de `9,00` para `10,00` não faça a linha saltar.

## Espaçamento e raios

Escala em múltiplos de 4dp: `Spacing.xs` (4) a `Spacing.xxxl` (48).
Raios por tamanho de elemento: `Radii.small` (8) → `Radii.sheet` (28).

Não se escrevem números à mão. Se falta um valor, acrescenta-se um token.

## Motion

`Motion.instant` (120ms) · `Motion.fast` (200ms) · `Motion.medium` (320ms) ·
`Motion.slow` (500ms), com `Motion.standard` como curva por omissão.

Onde é usado:

- **Transições de página** — `PredictiveBackPageTransitionsBuilder` no Android
  (suporta o gesto de recuar preditivo do Android 14+), `Cupertino` no iOS.
- **Hero** — o ícone de categoria voa do cartão para a barra do ecrã de detalhe
  (`ShoppingListCard.heroTag`).
- **Progresso** — `AppProgressBar` interpola o valor, por isso comprar um item
  faz a barra crescer em vez de saltar.
- **Entrada de lista** — `StaggeredEntrance` atrasa cada item 40ms, até ao
  sexto. Respeita `MediaQuery.disableAnimationsOf` (redução de movimento).
- **Estado do item** — o risco sobre o nome de um item comprado aparece com
  `AnimatedDefaultTextStyle`.
- **Passagem entre grupos** — marcar um item manda-o para o fim da lista e
  desmarcá-lo trá-lo de volta, em ambos os casos com transição. A lista de itens
  é uma `SliverAnimatedList`, a única que sabe animar entradas e saídas.

  O item que sai encolhe, desvanece e escorrega na direção para onde vai; o que
  chega assoma do lado de onde veio — por cima se desceu, por baixo se subiu. É
  esse detalhe que faz a transição ler-se como um movimento e não como dois
  acasos.

  **Consequência para quem lá mexer:** com uma `SliverAnimatedList`, a posição
  dos itens não pode ser mudada por reconstrução. Toda a mutação tem de passar
  por `insertItem`/`removeItem`, senão a lista em memória e o que está no ecrã
  dessincronizam. A regra de ordenação vive em
  [`item_ordering.dart`](../lib/pages/shoppinglist/item_ordering.dart), separada
  do ecrã e coberta por testes.

## Feedback tátil

- `selectionClick` ao marcar um item como comprado.
- `lightImpact` ao mudar a quantidade.
- `mediumImpact` ao apagar por arrasto e ao completar uma lista.

## Componentes partilhados

| Widget | Para quê |
|---|---|
| [`AppProgressBar`](../lib/pages/widgets/app_progress_bar.dart) | Progresso de uma lista, animado |
| [`AppEmptyState`](../lib/pages/widgets/app_empty_state.dart) | Estado vazio com ilustração e ação |
| [`AppSkeleton`](../lib/pages/widgets/app_skeleton.dart) | Placeholder de carregamento |
| [`ConfirmDialog`](../lib/pages/widgets/confirm_dialog.dart) | Confirmação de ação destrutiva |
| [`StaggeredEntrance`](../lib/pages/widgets/staggered_entrance.dart) | Entrada escalonada de itens de lista |
| [`ListTotals`](../lib/pages/shoppinglist/components/list_totals.dart) | Bloco "comprado / em falta" |

## Regras

1. **Cor vem do tema, nunca literal.** `Theme.of(context).colorScheme.onSurface`,
   não `Colors.black`. Um literal fica certo num tema e errado no outro.
2. **Layout não se calcula a partir do ecrã.** Nada de
   `height: size.height / 5` nem `Positioned(left: size.width * 0.85)`. Usa-se
   `Expanded`, `Wrap`, `Flexible`. As frações do ecrã funcionam no telemóvel
   onde foram afinadas e em mais nenhum.
3. **Listas longas são preguiçosas.** `ListView.builder` ou `SliverList.builder`,
   nunca `Column(children: List.generate(...))` dentro de um scroll.
4. **Um scroll por ecrã.** Dois `SingleChildScrollView` aninhados competem pelo
   gesto.
5. **Toque tem feedback.** `InkWell`/`InkResponse`, não `GestureDetector` nu.
6. **Alvo de toque mínimo de 48dp** (`Sizes.minTapTarget`).
7. **Texto visível ao utilizador vem das traduções**, não de literais.
