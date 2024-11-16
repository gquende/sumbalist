import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sumbalist/pages/home/components/drawer_widget.dart';
import 'package:sumbalist/pages/shoppinglist/components/create_list.dart';
import 'package:sumbalist/pages/shoppinglist/shopping_list_view.dart';

import '../../models/users.dart';
import '../../utils/constants/app_colors.dart';
//import 'components/drawer_widget.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: GestureDetector(
            onTap: () {
              if (User.logged?.status != null) {
                if (User.logged!.status == "unregistered") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text("Ainda não se registou😥"),
                    backgroundColor: Theme.of(context).primaryColor,
                  ));
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "👋Olá      ",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      "${User.logged?.name} ${User.logged?.surname}",
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: SizedBox(
              width: 20,
            ),
          ),
        ],
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: setPage(_currentIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARYCOLOR,
        onPressed: () {
          floatButtonAction();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget setPage(int page) {
    switch (page) {
      default:
        return const ShoppingListView();
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
