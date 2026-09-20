// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get languages => 'Languages';

  @override
  String get helloWorld => 'Hello World';

  @override
  String get login => 'Login';

  @override
  String get save => 'Save';

  @override
  String get doneList => 'Done List';

  @override
  String get completedLists => 'Completed List';

  @override
  String get doneLists => 'Done Lists';

  @override
  String get name => 'Name';

  @override
  String get amount => 'Amount';

  @override
  String get quantity => 'Quantity';

  @override
  String get update => 'Update';

  @override
  String get add => 'Add';

  @override
  String get noCompletedList => 'No completed list';

  @override
  String get noItemListToBuy => 'No items to purchase?';

  @override
  String get addItemAndBuy =>
      'Add items according to your priority and flag the purchased ones';

  @override
  String get hello => 'Hello';

  @override
  String get price => 'Price';

  @override
  String get description => 'Description';

  @override
  String get status => 'Status';

  @override
  String get general => 'General';

  @override
  String get school => 'School';

  @override
  String get party => 'Party';

  @override
  String get house => 'House';

  @override
  String get myList => 'My Lists';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get completed => 'Completed';

  @override
  String get remaining => 'Remaining';

  @override
  String get currency => 'Currency';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get confirm => 'Confirm';

  @override
  String get whatAreYouGoingToBuyToday => 'What are you going to buy today?';

  @override
  String get createAListAndFollowUp => 'Create a list and follow up';

  @override
  String get youhaveNotRegisteredYet => 'You have not registered yet😥';

  @override
  String get category => 'Category';

  @override
  String get planYourShoppingList => 'Plan your shopping list';

  @override
  String get theSecretToEfficient =>
      'The secret to efficient shopping is planning your shopping list. Save time by planning your shopping list';

  @override
  String get efficientShoppingList => 'Efficient shopping list';

  @override
  String get makeYourGroceryShoppingAnEfficient =>
      'Make your grocery shopping an efficient, hassle-free experience';

  @override
  String get beHappy => 'Be happy';

  @override
  String get beHappyWithSumbalist =>
      'Be happy with your purchases using Sumbalist';

  @override
  String get newVersionTitle => 'New version';

  @override
  String get versionMessage =>
      'Your version is out of date, download new version from store app';

  @override
  String get toContinue => 'Continue';

  @override
  String get listName => 'List name';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteListTitle => 'Delete list?';

  @override
  String deleteListMessage(String name) {
    return 'This action cannot be undone. The list \"$name\" and all its items will be removed.';
  }

  @override
  String get listDeleted => 'List deleted';

  @override
  String get createFirstList => 'Create my first list';

  @override
  String itemsProgress(int bought, int total) {
    return '$bought of $total items';
  }

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get newList => 'New list';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';
}
