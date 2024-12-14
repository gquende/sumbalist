


# SumbaList

SumbaList é uma aplicação móvel projetada para facilitar a organização e gestão de compras do dia a dia. Esta aplicação visa simplificar o processo de criar e gerenciar listas de compras, tornando a experiência de compras mais eficiente e conveniente para os utilizadores..

![GitHub Cards Preview](https://github.com/gquende/sumbalist/blob/develop/images/banner.png)



## Demonstração


<img src="https://github.com/gquende/sumbalist/blob/develop/images/1.png" height="300em" /> <img src="https://github.com/gquende/sumbalist/blob/develop/images/2.png" height="300em" /> <img src="https://github.com/gquende/sumbalist/blob/develop/images/3.png" height="300em" /> <img src="https://github.com/gquende/sumbalist/blob/develop/images/4.png" height="300em" />


## Funcionalidades ✨

* [x] OnBoarding
* [x] Autenticação
* [x] Modo claro e escuro
* [x] Criar Lista de compras
* [x] Eliminar Lista de compras
* [x] Actualizar Lista de compras
* [x] Adicionar items na lista de compras
* [x] Remover items na lista de compras
* [x] Actualizar items na lista de compras
* [x] Seleccionar moeda para preços
* [x] Visualizar listas concluídas
* [x] Multi-línguas


## Stack utilizada

* Flutter
* Firebase

## Arquitectura de Desenvolvimento

A aplicação foi construída usando uma arquitetura baseado em Model-View-ViewModel (MVVM).
Este padrão de desenho ajuda na separação dos dados,
UI e lógica de negócio, permitindo uma base de código mais modular e
testável. A mesma é aprimorada com a biblioteca GetX para gerenciamento de estado de forma reactiva

## Executando localmente

Clone o projecto

```bash
  git clone https://github.com/gquende/sumbalist
```

Entre no diretório do projecto

```bash
  cd sumbalist
```

Instale as dependências

```bash
  flutter pub get
```

```bash
 flutter gen-l10n --template-arb-file=intl_en.arb
 flutter pub run intl_utils:generate
```


Confirme que tenha um telemóvel ou emulador rodando e execute:

```bash
  flutter run
```


