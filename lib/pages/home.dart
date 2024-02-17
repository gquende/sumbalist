import 'package:flutter/material.dart';
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
          "Sumbalist",
        ),
      ),
      body: SingleChildScrollView(
        child: setPage(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: SECONDARYCOLOR,
        selectedItemColor: PRIMARYCOLOR,
        unselectedItemColor: Colors.white,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Resumo"),
          /*BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: "Cozinha"),*/
          BottomNavigationBarItem(
              icon: Icon(Icons.storefront_rounded), label: "Compras"),
          /* BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service), label: "Manutenções"),*/
        ],
      ),
      floatingActionButton: _currentIndex != 0
          ? FloatingActionButton(
              backgroundColor: PRIMARYCOLOR,
              onPressed: () {
                floatButtonAction();
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget setPage(int page) {
    switch (page) {
      case 0:
        return Center(
          child: Text("Resumo"),
        );

      case 1:
        return ShoppingListView();

      case 2:
        return ShoppingListView();

      case 3:
        return Center(
          child: Text("Manutenções"),
        );

      default:
        return Container();
    }
  }

  void floatButtonAction() {
    switch (_currentIndex) {
      case 1:
        {
          shoplistForm(context);
        }
        break;
    }
  }
}
