# Funcionalidades possíveis

Levantamento feito a ler o código, não a imaginar o produto. Cada item aponta
para onde já existe alguma coisa, para se perceber o que é acabamento e o que é
construção de raiz.

A ordem não é por ambição, é por dependência: há trabalho na secção 1 que
bloqueia metade da secção 3.

---

## 1. Bloqueadores

Coisas que convém resolver antes de acrescentar funcionalidades, porque ou
limitam o que se pode construir, ou são risco na loja.

### 1.1 Permissões de contactos declaradas sem utilização

O manifesto pede `READ_CONTACTS` e `WRITE_CONTACTS`:

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
```

Mas `lib/controllers/contacts_controller.dart` e `lib/pages/contacts_list.dart`
estão **inteiramente comentados**. Nenhuma linha de código ativo lê contactos, e
`permission_handler` é hoje uma dependência morta.

Contactos são dados pessoais sensíveis para o Google Play: pedi-los sem uso
obriga a justificá-los na Segurança dos Dados e é motivo frequente de rejeição.
São duas linhas a remover — ou, se a partilha por contactos for para avançar
(§3.1), fica justificado e resolve-se sozinho.

### 1.2 O serviço de localização não funciona em Android moderno

`lib/services/location_service.dart` chama `http://ip-api.com/json` — **HTTP em
claro**. O Android bloqueia tráfego não cifrado por omissão desde a API 28 e o
manifesto não abre exceção. Além disso usa `dio.post` num endpoint que só
responde a `GET`.

Está no fluxo de registo (`signup_controller.dart`), a detetar país e moeda do
utilizador. Na prática, falha em silêncio. Passar para `https://` e `GET`
resolve o essencial.

### 1.3 O esquema da base de dados tem uma vírgula em falta

```dart
// lib/core/database.dart:87-89
priority integer,
isDone integer      // <- falta a vírgula
statusUUID TEXT,
```

O SQLite aceita nomes de tipo com várias palavras, por isso não dá erro: cria a
coluna `isDone` com o tipo `integer statusUUID TEXT` e a coluna `statusUUID`
**nunca chega a existir**. Hoje é inofensivo porque `ShoppinglistItem` não tem
esse campo, mas é uma mina para quem lá mexer.

### 1.4 Não há migrações

A base de dados abre com `version: 1` e só define `onCreate`. Não existe
`onUpgrade`.

Isto é o verdadeiro bloqueador: **qualquer funcionalidade que acrescente uma
coluna obriga os utilizadores existentes a reinstalar a app para não rebentar**.
Unidades de medida, orçamento, categorias personalizadas, histórico de preços —
tudo o que está na secção 3 precisa disto primeiro.

### 1.5 A sincronização só puxa no login

`loadShoppingList()` é chamado apenas em `login_controller.dart`. Depois disso a
app só *empurra* para o Firebase. Duas consequências:

- Quem usa a app em dois dispositivos não vê as alterações do outro sem voltar
  a entrar.
- Não há resolução de conflitos: ganha a última escrita, em silêncio.

O Realtime Database é, por natureza, um canal ao vivo. Trocar o `get()` por um
`onValue` já resolveria a maior parte, e é pré-requisito da partilha (§3.1).

---

## 2. Já meio-construído

Funcionalidades cujo modelo de dados já existe e só não têm interface. São as
mais baratas por unidade de valor.

### 2.1 Prioridade de itens

`priority` está na tabela, no modelo, e é lido e escrito pelo formulário — mas
**nenhum ecrã alguma vez lhe atribui um valor**. É sempre `1`.

```
lib/core/database.dart:87                    priority integer,
lib/models/shopping_list_item.dart:10        int priority;
lib/pages/.../item_form_sheet.dart:102       priority: _controller.priority,
```

Falta um seletor de três níveis no formulário de item e a ordenação da lista por
prioridade. Nada de esquema novo, nada de migração.

### 2.2 Progresso por valor, e não por número de itens

`ShoppingList` tem dois cálculos:

```dart
double getPercentBuyed()        // por dinheiro — nunca é chamado
double getPercentBuyedByItem()  // por contagem — é o que se usa
```

Comprar 8 de 10 itens baratos não é o mesmo que comprar 8 de 10 quando os dois
que faltam são metade do orçamento. Alternar entre os dois — ou mostrar ambos —
é uma linha de UI sobre um método que já existe.

### 2.3 Estado das listas como entidade

Existem um modelo `Status` e uma tabela `status`, ambos sem uso. Hoje o estado é
uma string solta comparada por igualdade (`"completed"` / `"not completed"`),
espalhada por vários ficheiros. Formalizá-la abre a porta a estados como
*arquivada* ou *modelo* (§3.3).

### 2.4 Contactos

Está escrito, testado até certo ponto, e comentado. Ou se apaga (§1.1) ou se
retoma como base da partilha (§3.1). O que não faz sentido é ficar como está.

---

## 3. Funcionalidades novas

| Funcionalidade | Valor | Esforço | Depende de |
|---|---|---|---|
| Desfazer ao apagar | Alto | Baixo | — |
| Pesquisa e filtros | Alto | Baixo | — |
| Ordenação de itens | Alto | Baixo | §2.1 |
| Orçamento por lista | Alto | Médio | §1.4 |
| Unidades de medida | Alto | Médio | §1.4 |
| Duplicar lista / modelos | Alto | Médio | §1.4, §2.3 |
| Partilha e colaboração | Muito alto | Alto | §1.1, §1.5 |
| Histórico e estatísticas | Alto | Médio | — |
| Categorias personalizadas | Médio | Médio | §1.4 |
| Notificações | Médio | Médio | §1.5 |
| Código de barras | Médio | Alto | §1.4 |
| Histórico de preços | Muito alto | Alto | §1.4, §3.7 |
| Exportar (PDF/CSV) | Médio | Baixo | — |

### 3.1 Partilha e colaboração

A funcionalidade de maior valor, e a estrutura do Firebase já está preparada
para ela:

```
shoppinglists/{listUuid}        a lista
user-lists/{userUuid}/{listUuid}  índice de quem a vê
```

A lista já está guardada num nó próprio, separada do índice por utilizador.
Acrescentar `list-members/{listUuid}/{userUuid}` e escrever no índice de mais do
que um utilizador dá partilha sem mexer no modelo de dados.

Casos de uso reais: duas pessoas da mesma casa a comprar em sítios diferentes, a
verem em tempo real o que o outro já meteu no carrinho.

Precisa de §1.5 (sincronização ao vivo, senão a colaboração não se vê) e obriga
a decidir §1.1 (convidar por contacto, por telefone ou por link).

Nota: o registo já escreve um índice `phones/{numero} → uuid` no Firebase
(`firebase_service.dart:67`). Isso permite convidar por número — mas, se as
regras do Realtime Database não estiverem fechadas, é também uma lista de
telefones legível por qualquer pessoa. **Convém rever as regras antes de
construir partilha por cima disto.**

### 3.2 Orçamento por lista

Um tecto de despesa definido ao criar a lista, com a barra de progresso a mudar
de cor ao aproximar-se e um aviso ao ultrapassar.

Encaixa no que já existe: `AppProgressBar` já muda de cor ao chegar aos 100%, e
`AppSemanticColors` já tem `warning` definido e por usar. Pede uma coluna
`budget` em `shoppinglist` — daí depender de §1.4.

### 3.3 Listas modelo e recorrentes

Uma compra de supermercado repete-se. Poder duplicar uma lista concluída, ou
marcar uma como modelo, poupa o trabalho mais aborrecido da app.

Barato em código — os dados já lá estão, listas concluídas não são apagadas —
mas precisa de §2.3 para distinguir *modelo* de *concluída*.

### 3.4 Unidades de medida

Hoje um item tem `qty` como inteiro. "2 kg de arroz" e "2 pacotes de arroz" são
coisas diferentes, e sem unidade o total também não bate certo para produtos a
peso. Pede uma coluna `unit` e um seletor no formulário.

### 3.5 Pesquisa e filtros

Não existe pesquisa em lado nenhum. Com dez ou mais listas, encontrar uma
obriga a percorrê-las a olho. Com o `SliverList` já no sítio, é acrescentar um
`SliverAppBar` com campo de pesquisa e filtrar em memória.

### 3.6 Histórico e estatísticas

As listas concluídas já ficam guardadas com data e categoria. Isso chega para
mostrar quanto se gastou por mês, por categoria, e a evolução ao longo do tempo
— sem recolher um único dado novo.

Num mercado com inflação alta como o angolano (a app já tem o kwanza como moeda
de referência em `utils/currency.dart`), ver a despesa mensal a subir é
informação com peso real.

### 3.7 Histórico de preços por produto

A continuação natural de §3.6, e provavelmente a funcionalidade mais defensável
do produto: guardar o preço pago por cada produto ao longo do tempo e avisar
quando o preço de hoje está acima do costume.

Precisa de uma entidade *produto* separada de *item de lista* — hoje o nome do
item é texto livre, por isso "Arroz 5kg" e "arroz 5 kg" são coisas distintas.
É o item mais caro da lista, e o que mais distingue a app de um bloco de notas.

### 3.8 Desfazer ao apagar

Apagar uma lista ou um item é definitivo. Já existe confirmação para listas, mas
um item arrastado desaparece sem rede de segurança. Um `SnackBar` com *Anular*,
a segurar a remoção durante alguns segundos, é trabalho de uma tarde.

Ficou mais barato desde que a lista passou a `SliverAnimatedList`: repor o item
é um `insertItem` no índice que `ItemOrdering.targetIndex` devolver.

### 3.9 Exportar

Partilhar uma lista com quem não tem a app: gerar texto simples para WhatsApp,
ou um PDF do recibo da compra. Simples, e útil antes de a partilha nativa
(§3.1) existir.

---

## 4. Ordem sugerida

**Primeiro**, porque desbloqueia o resto e tira risco da loja:
§1.1 permissões · §1.2 HTTPS · §1.3 vírgula · §1.4 migrações

**Depois**, valor imediato e pouco código:
§3.8 desfazer · §3.5 pesquisa · §2.1 prioridade · §2.2 progresso por valor ·
§3.9 exportar

**A seguir**, o que dá identidade ao produto:
§3.2 orçamento · §3.3 modelos · §3.6 estatísticas

**Por fim**, os dois grandes:
§1.5 + §3.1 partilha ao vivo · §3.7 histórico de preços

---

## 5. Fora do âmbito de funcionalidades

Trabalho técnico já identificado em
[refatoracao-ui.md](refatoracao-ui.md#o-que-ficou-por-fazer), e que compete com
o que está acima pelo mesmo tempo:

- Unificar a gestão de estado (GetX + Provider + get_it em simultâneo).
- Redesenhar os ecrãs de autenticação, onboarding e drawer.
- Testes de widget — não existe nenhum. Dos 31 testes atuais, 18 passam (tema e
  ordenação de itens) e 13 falham por dependerem de Firebase e de rede reais.
  Essas falhas são anteriores à refatoração de UI.
- iOS não tem *schemes* correspondentes aos flavors `dev`/`prod` do Android:
  só existe `Runner.xcscheme`.
