import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/models/users.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../mocks/shopping_list_category_mock.dart';
import '../../../models/shopping_list.dart';
import '../../../models/shopping_list_categories.dart';
import '../../../utils/constants/app_colors.dart';
import '../shopping_list_details.dart';

Future<void> shoplistForm(BuildContext context, [ShoppingList? item]) async {
  var controller = await GetIt.instance.get<ShoppingListController>();

  var size = MediaQuery.of(context).size;
  TextEditingController shoplistNameController = TextEditingController();

  var index = 0.obs;

  if (item != null) {
    shoplistNameController.text = item.name;

    index.value = int.parse(item.categoryUUID);
  }

  await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(child: Obx(() {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Categoria"),
                          const SizedBox(
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
                          const SizedBox(
                            height: 20,
                          ),
                          // const Text("Nome da lista"),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: size.width,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: shoplistNameController,
                                decoration: InputDecoration(
                                    hintText: "Nome da lista",
                                    contentPadding: EdgeInsets.only(bottom: 10),
                                    focusColor: Color(0xff000000),
                                    filled: true,
                                    prefixIcon: Icon(
                                      CupertinoIcons.square_list,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    labelStyle:
                                        TextStyle(color: Color(0xff000000)),
                                    border: OutlineInputBorder()),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (shoplistNameController.text.isNotEmpty) {
                                if (item == null) {
                                  var uuid = const Uuid();
                                  var shoplist = ShoppingList(
                                      uuid: uuid.v4(),
                                      userUUID:
                                          User.logged?.uuid ?? 'not defined',
                                      categoryUUID: "$index",
                                      statusUUID: "Open",
                                      name: shoplistNameController.text,
                                      total: 0,
                                      items: []);

                                  await controller.createShoppinglist(shoplist);

                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (ctx) => ShoplistDetails(
                                              shoppingList: shoplist)));
                                } else {
                                  item.name = shoplistNameController.text;
                                  item.categoryUUID = "${index.value}";

                                  controller.updateShoppinglist(item);
                                  Navigator.pop(context);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
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
                                      const BoxShadow(
                                          offset: Offset(0, 0),
                                          color: Colors.black12,
                                          spreadRadius: .7,
                                          blurRadius: 2)
                                    ],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: item == null
                                      ? const Text(
                                          "Adicionar",
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : const Text(
                                          "Actualizar",
                                          style: TextStyle(color: Colors.black),
                                        ),
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
  return Column(
    children: [
      Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: active
                ? const Color.fromRGBO(253, 185, 19, 0.1)
                : Theme.of(context).colorScheme.secondaryContainer,
            border: active ? Border.all(color: PRIMARYCOLOR) : null),
        child: Icon(
          category.icon,
          color:
              active ? Theme.of(context).primaryColor : const Color(0xff9C9C9C),
        ),
      ),
      Text(
        "${category.name}",
        style: TextStyle(
            color: active ? Theme.of(context).primaryColor : Colors.grey),
      )
    ],
  );
}
