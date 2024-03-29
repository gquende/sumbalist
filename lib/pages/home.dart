import 'package:currency_formatter/currency_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/pages/shoppinglist/components/create_list.dart';
import 'package:sumbalist/pages/shoppinglist/shopping_list_view.dart';
import 'package:sumbalist/utils/theme/theme.dart';

import '../models/users.dart';
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                child: Icon(Icons.person),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Olá,",
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
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(onTap: () {
              //Change theme Mode
              AppTheme.setDarkMode(!AppTheme.isDarkMode.value);
            }, child: Obx(() {
              return AppTheme.isDarkMode.value
                  ? Icon(CupertinoIcons.lightbulb)
                  : Icon(
                      CupertinoIcons.lightbulb_fill,
                      color: Theme.of(context).primaryColor,
                    );
            })),
          )
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
    CurrencyFormatter.majorsList.forEach((element) {
      print(element.symbol + "- ${element.code}");
      print(element.symbol);
    });

    switch (_currentIndex) {
      case 0:
        {
          shoplistForm(context);
        }
        break;
    }
  }
}
