import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/files.dart';
import 'components/add_item.dart';

class ShoplistDetails extends StatefulWidget {
  ShoppingList shoppingList;

  ShoplistDetails({required this.shoppingList});

  @override
  State<ShoplistDetails> createState() => _ShoplistDetailsState();
}

class _ShoplistDetailsState extends State<ShoplistDetails> {
  var controller = GetIt.instance.get<ShoppingListController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.shoppingList.value = widget.shoppingList;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARYCOLOR,
        title: Text("${widget.shoppingList.name}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 7,
                            spreadRadius: 3)
                      ]),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Obx(() {
                        return Column(
                          children: [
                            Text(
                              "${controller.shoppingList.value.name}",
                              style: TextStyle(fontSize: 24),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "\$ ${controller.shoppingList.value.calculateTotal()}",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${controller.shoppingList.value.getPercentBuyed().round()}% Concluído",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 16,
                                          color: Colors.grey),
                                      // style: Text(),
                                    ),
                                    Text(
                                      "${controller.shoppingList.value.calculateTotalBuyed()} AOA",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 18,
                                          color: Colors.grey),
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
                                      "${controller.shoppingList.value.calculateTotal() - controller.shoppingList.value.calculateTotalBuyed()} AOA",
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Medium',
                                          fontSize: 18,
                                          color: PRIMARYCOLOR),
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
                                  height: 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          Color(0xff67727d).withOpacity(0.1)),
                                ),
                                Container(
                                  width: (size.width - 40) *
                                      controller.shoppingList.value
                                          .getPercentBuyed() /
                                      100,
                                  height: 12,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: PRIMARYCOLOR),
                                ),
                              ],
                            )
                          ],
                        );
                      })),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: controller
                        .getItemsOfShoppingList(widget.shoppingList.uuid),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snap.data == null || snap.data?.length == 0) {
                        return Container(
                          width: size.width,
                          height: size.height / 1.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  AppAssets.ADD_NOTE_IMAGE,
                                  width: size.width / 2,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Sem items por comprar?",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Adicione items conforme a sua prioridade, e sinalize os comprados",
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: List.generate(
                            snap.data?.length ?? 0,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: _shoppinglistItemWidget(
                                      item: snap.data![index]),
                                )),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.bottomSheet(
            AddItemBody(list: widget.shoppingList),
            backgroundColor: Colors.white,
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
        backgroundColor: PRIMARYCOLOR,
      ),
    );
  }

  Widget _shoppinglistItemWidget({required ShoppinglistItem item}) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Container(
                width: size.width * 0.5,
                height: size.height * 0.4,
              );
            });
      },
      child: Container(
        width: size.width,
        height: 80,
        decoration: BoxDecoration(
            color: Color(0xfff2f2f2), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.foggy),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(
                        height: size.height * 0.006,
                      ),
                      Row(
                        children: [
                          Text("Qtd: ${item.qty}"),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Preço: ${item.price}'),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Prioride: ${item.priority}')
                        ],
                      )
                    ],
                  ),
                ],
              ),
              Checkbox(
                value: item.isDone,
                onChanged: (value) {
                  item.isDone = value!;

                  controller.updateItem(item).then((value) {
                    setState(() {
                      controller.shoppingList.refresh();
                    });
                  });
                },
                activeColor: PRIMARYCOLOR,
                focusColor: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
