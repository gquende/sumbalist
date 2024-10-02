import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/mocks/shopping_list_category_mock.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../models/shopping_list.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/currency.dart';
import '../shopping_list_details.dart';
import 'create_list.dart';

class ShoppingListCard extends StatelessWidget {
  ShoppingList shoppinglist;

  var controller = GetIt.instance.get<ShoppingListController>();

  ShoppingListCard(this.shoppinglist);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) =>
                ShoplistDetails(shoppingList: this.shoppinglist)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primaryContainer,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 11,
                  spreadRadius: 2)
            ]),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(253, 185, 19, 0.2),
                                ),
                                child: Icon(
                                  iconCategory["${shoppinglist.categoryUUID}"],
                                  size: 35,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width / 1.8,
                                    child: Text(
                                      "${shoppinglist.name}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    AppCurrencyFormat.format(
                                        shoppinglist.calculateTotal()),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Concluído",
                                style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 16,
                                ),
                                // style: Text(),
                              ),
                              Text(
                                "${AppCurrencyFormat.format(shoppinglist.calculateTotalBuyed())} (${shoppinglist.calculateTotalItemBuyed()})",
                                style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Restante",

                                style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 16,
                                    color: Colors.grey),
                                // style: Text(),
                              ),
                              Text(
                                "${AppCurrencyFormat.format(shoppinglist.calculateTotal() - shoppinglist.calculateTotalBuyed())} (${shoppinglist.calculateTotalItemPending()})",
                                style: TextStyle(
                                    fontFamily: 'Poppins-Medium',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: (size.width - 40),
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xff67727d).withOpacity(0.1)),
                          ),
                          Container(
                            width: (size.width - 40) *
                                shoppinglist.getPercentBuyedByItem() /
                                100,
                            height: 14,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: PRIMARYCOLOR),
                          ),
                          Positioned(
                              left: (size.width - 50) / 2,
                              child: Text(
                                  "${(shoppinglist.getPercentBuyedByItem()).round()} %"))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: size.width * 0.85,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {
                          shoplistForm(context, shoppinglist);
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Editar")
                          ],
                        )),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Eliminar")
                        ],
                      ),
                      onTap: () {
                        controller.deleteShoppinglist(shoppinglist);
                      },
                    )
                  ];
                },
                icon: Row(
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: Colors.grey[300],
                    ),
                    SizedBox(
                      width: 5,
                    )
                  ],
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }
}
