import 'package:flutter/material.dart';
import 'package:sumbalist/pages/contacts_list.dart';
import 'package:sumbalist/pages/shoppinglist/components/create_list.dart';
import 'package:sumbalist/pages/shoppinglist/shopping_list_view.dart';

import '../utils/constants/app_colors.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "🛍SumbaList",
        ),
      ),
      body: SingleChildScrollView(
        child: setPage(_currentIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARYCOLOR,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ContactsList()));

          //floatButtonAction();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget setPage(int page) {
    switch (page) {
      default:
        return ShoppingListView();
    }
  }

  void floatButtonAction() {
    switch (_currentIndex) {
      case 0:
        {
          shoplistForm(context);
        }
        break;
    }
  }
}
