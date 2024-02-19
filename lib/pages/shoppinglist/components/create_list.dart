import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../mocks/shopping_list_category_mock.dart';
import '../../../models/shopping_list.dart';
import '../../../models/shopping_list_categories.dart';
import '../../../utils/constants/app_colors.dart';
import '../shopping_list_details.dart';

Future<void> shoplistForm(BuildContext context) async {
  var controller = await GetIt.instance.get<ShoppingListController>();

  var size = MediaQuery.of(context).size;
  TextEditingController shoplistNameController = TextEditingController();

  var index = 0.obs;

  var categorySelected = ShoppingListCategory(uuid: '', name: '').obs;
  categorySelected.value = shoppingListCategoriesMock.first;

  await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(child: Obx(() {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text("Categoria"),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  shoppingListCategoriesMock.length, (i) {
                                return GestureDetector(
                                  onTap: () {
                                    index.value = i; //Set category by index
                                  },
                                  child: categoryIcon(index == i,
                                      shoppingListCategoriesMock[i], context),
                                );
                              })),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Nome da lista"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: size.width,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  /* BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Colors.black12,
                                      spreadRadius: .7,
                                      blurRadius: 0)*/
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: TextField(
                                controller: shoplistNameController,
                                maxLines: 6,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              debugPrint("Saindo...");

                              var controller = await GetIt.instance
                                  .get<ShoppingListController>();

                              if (shoplistNameController.text.isNotEmpty &&
                                  categorySelected != null) {
                                var uuid = Uuid();

                                var shoplist = ShoppingList(
                                    uuid: uuid.v4(),
                                    userUUID: "dede",
                                    categoryUUID: "$index",
                                    statusUUID: "Aberto",
                                    name: shoplistNameController.text,
                                    total: 0,
                                    items: []);

                                await controller.createShoppinglist(shoplist);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (ctx) => ShoplistDetails(
                                            shoppingList: shoplist)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Insere um nome para lista e seleccione uma categoria")));
                              }
                            },
                            child: Container(
                                width: size.width,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: PRIMARYCOLOR,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 0),
                                          color: Colors.black12,
                                          spreadRadius: .7,
                                          blurRadius: 2)
                                    ],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text("Adicionar"),
                                )),
                          ),
                        ],
                      )));
            })),
          ),
        );
      });

  return null;
}

Widget categoryIcon(
    bool active, ShoppingListCategory category, BuildContext context) {
  return Container(
    width: 55,
    height: 55,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: active ? Color.fromRGBO(253, 185, 19, 0.1) : Color(0xffF9F9F9),
        border: active ? Border.all(color: PRIMARYCOLOR) : null),
    child: Icon(
      category.icon,
      color: active ? Theme.of(context).primaryColor : Color(0xff9C9C9C),
    ),
  );
}
