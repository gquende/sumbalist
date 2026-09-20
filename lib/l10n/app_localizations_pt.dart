// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get language => 'Língua';

  @override
  String get languages => 'Línguas';

  @override
  String get helloWorld => 'Olá mundo';

  @override
  String get login => 'Entrar';

  @override
  String get save => 'Salvar';

  @override
  String get doneList => 'Lista concluída';

  @override
  String get completedLists => 'Listas concluídas';

  @override
  String get doneLists => 'Listas concluídas';

  @override
  String get name => 'Nome';

  @override
  String get amount => 'Quantidade';

  @override
  String get quantity => 'Quantidade';

  @override
  String get update => 'Actualizar';

  @override
  String get add => 'Adicionar';

  @override
  String get noCompletedList => 'Sem lista concluída';

  @override
  String get noItemListToBuy => 'Sem items por comprar?';

  @override
  String get addItemAndBuy =>
      'Adicione items conforme a sua prioridade e sinalize os comprados';

  @override
  String get hello => 'Olá';

  @override
  String get price => 'Preço';

  @override
  String get description => 'Descrição';

  @override
  String get status => 'Estado';

  @override
  String get general => 'Geral';

  @override
  String get school => 'Escola';

  @override
  String get party => 'Festa';

  @override
  String get house => 'Casa';

  @override
  String get myList => 'Minhas listas';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Apagar';

  @override
  String get completed => 'Concluído';

  @override
  String get remaining => 'Restante';

  @override
  String get currency => 'Moeda';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get whatAreYouGoingToBuyToday => 'O que vai comprar hoje?';

  @override
  String get createAListAndFollowUp => 'Crie uma lista e acompanhe';

  @override
  String get youhaveNotRegisteredYet => 'Você ainda não se registou😥';

  @override
  String get category => 'Categoria';

  @override
  String get planYourShoppingList => 'Planeie sua lista compra';

  @override
  String get theSecretToEfficient =>
      'O segredo para uma compra eficiente está no planeamento da sua lista de compra. Economize tempo planeando a sua lista de compras';

  @override
  String get efficientShoppingList => 'Lista de compras eficiente';

  @override
  String get makeYourGroceryShoppingAnEfficient =>
      'Transforme suas idas ao mercado em uma experiência eficiente e sem complicações';

  @override
  String get beHappy => 'Seja feliz';

  @override
  String get beHappyWithSumbalist =>
      'Seja feliz com suas compras usando Sumbalist';

  @override
  String get newVersionTitle => 'Nova versão';

  @override
  String get versionMessage =>
      'A sua versão está desactualizada, baixe nova versão na loja de aplicativos';

  @override
  String get toContinue => 'Continuar';

  @override
  String get listName => 'Nome da lista';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteListTitle => 'Apagar lista?';

  @override
  String deleteListMessage(String name) {
    return 'Esta acção não pode ser anulada. A lista \"$name\" e todos os seus itens serão removidos.';
  }

  @override
  String get listDeleted => 'Lista apagada';

  @override
  String get createFirstList => 'Criar a minha primeira lista';

  @override
  String itemsProgress(int bought, int total) {
    return '$bought de $total itens';
  }

  @override
  String get fillAllFields => 'Preencha todos os campos';

  @override
  String get newList => 'Nova lista';

  @override
  String get decreaseQuantity => 'Diminuir quantidade';

  @override
  String get increaseQuantity => 'Aumentar quantidade';

  @override
  String get defaultCurrency => 'Predefinida';

  @override
  String get useDefaultCurrency => 'Usar a predefinida';

  @override
  String get search => 'Procurar';
}
