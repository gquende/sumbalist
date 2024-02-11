import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/shopping_list_controller.dart';
import '../../../mocks/mocks.dart';
import '../../../models/list_categories.dart';
import '../../../models/shopping_list.dart';
import '../shopping_list_details.dart';

Future<void> shoplistForm(BuildContext context) async {
  var controller = await GetIt.instance.get<ShoppingListController>();

  var size = MediaQuery.of(context).size;
  TextEditingController shoplistNameController = TextEditingController();

  var categorySelected = ListCategory(uuid: '', name: '').obs;
  categorySelected.value = shoplistCategories.first;

  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
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
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 0.3),
                                      spreadRadius: 1,
                                      blurRadius: 1)
                                ]),
                            width: size.width * 0.895,
                            height: 55,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Obx(() {
                                  return DropdownButton<ListCategory>(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      value: categorySelected.value,
                                      items: shoplistCategories
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e.name)))
                                          .toList(),
                                      onChanged: (value) {
                                        categorySelected.value = value!;
                                      });
                                })),
                          ),
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
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      color: Colors.black12,
                                      spreadRadius: .7,
                                      blurRadius: 0)
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
                                    categoryUUID: "dedede",
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
                      ))),
            ),
          ),
        );
      });

  return null;
}
