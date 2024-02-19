import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../models/shopping_list.dart';
import '../../models/shopping_list_item.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/files.dart';
import '../widgets/common_button.dart';

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
    controller.shoppingList.value = widget.shoppingList;
    controller.getItemsOfShoppingList(widget.shoppingList.uuid).then((value) {
      controller.shoppingList.value.items = value;
    });
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
              child: Obx(() {
                return Column(
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
                            child: Column(
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
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xff67727d)
                                              .withOpacity(0.1)),
                                    ),
                                    Container(
                                      width: (size.width - 40) *
                                          controller.shoppingList.value
                                              .getPercentBuyed() /
                                          100,
                                      height: 12,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: PRIMARYCOLOR),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    controller.shoppingList.value.items!.length == 0
                        ? Container(
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                          )
                        : Column(
                            children: List.generate(
                                controller.shoppingList.value.items!.length ??
                                    0,
                                (index) => Dismissible(
                                      key: UniqueKey(),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: _shoppinglistItemWidget(
                                            item: controller.shoppingList.value
                                                .items![index]),
                                      ),
                                      onDismissed: (direction) {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          controller
                                              .removeItem(controller
                                                  .shoppingList
                                                  .value
                                                  .items![index])
                                              .then((value) {});
                                        }
                                      },
                                    )),
                          ),
                  ],
                );
              })),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModal(null).then((value) {
            setState(() {});
          });

          /*
          Get.bottomSheet(
            AddItemBody(list: widget.shoppingList),
            backgroundColor: Colors.white,
          ).then((value) {
            setState(() {});
          });*/
        },
        child: Icon(Icons.add),
        backgroundColor: PRIMARYCOLOR,
      ),
    );
  }

  Widget _shoppinglistItemWidget({required ShoppinglistItem item}) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width,
          height: 80,
          decoration: BoxDecoration(
              color: Color(0xfff2f2f2), borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await showModal(item);
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Theme.of(context).primaryColor),
                        alignment: Alignment.center,
                        child: Icon(Icons.shopping_cart),
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
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          SizedBox(
                            height: size.height * 0.006,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${item.price * item.qty} AOA",
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            left: size.width / 1.42,
            top: 43,
            child: Container(
              height: 25,
              width: 100,
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.qty > 1) {
                        item.qty--;
                        controller.updateItem(item).then((value) {
                          setState(() {});
                        });

                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          )),
                      child: Text(
                        "-",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                  ),
                  Text(
                    "${item.qty}",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  GestureDetector(
                    onTap: () {
                      item.qty++;

                      controller.updateItem(item).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          )),
                      child: Text(
                        "+",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
            )),
        Positioned(
            left: size.width / 1.16,
            top: -3,
            child: Checkbox(
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
            ))
      ],
    );
  }

  Future<void> showModal(ShoppinglistItem? item) async {
    var size = MediaQuery.of(context).size;

    var priority = 1.obs;
    var categoryIdSelected = 1.obs;

    if (item != null) {
      controller.nameFieldController.text = item!.itemName;
      controller.descriptionController.text = item!.description;
      controller.qtyController.text = "${item!.qty}";
      controller.priceController.text = "${item!.price}";
      controller.priority = item!.priority;
      priority.value = item!.priority;
    }
    await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Wrap(children: [
            Obx(() {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Nome"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: controller.nameFieldController,
                            decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Preço"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Quantidade"),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: controller.qtyController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Descrição"),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: controller.descriptionController,
                            decoration: InputDecoration(
                                hintText: "",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Prioridade",
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: priority.value,
                                      onChanged: (value) {
                                        setState(() {
                                          priority.value = value as int;
                                        });
                                      }),
                                  Text("1"),
                                ],
                              ),
                              Column(
                                children: [
                                  Radio(
                                      value: 2,
                                      groupValue: priority.value,
                                      onChanged: (value) {
                                        setState(() {
                                          priority.value = value as int;
                                        });
                                      }),
                                  Text("2"),
                                ],
                              ),
                              Column(
                                children: [
                                  Radio(
                                      value: 3,
                                      groupValue: priority.value,
                                      onChanged: (value) {
                                        setState(() {
                                          priority.value = value as int;
                                        });
                                      }),
                                  Text("3"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CommonButton(
                          active: true,
                          title: item == null ? "Adicionar" : "Actualizar",
                          action: () async {
                            if (item == null) {
                              var uuid = Uuid();

                              ShoppinglistItem item = ShoppinglistItem(
                                  uuid: uuid.v4(),
                                  isDone: false,
                                  listUUID: widget.shoppingList.uuid,
                                  itemName: controller.nameFieldController.text,
                                  description:
                                      controller.descriptionController.text,
                                  qty: int.parse(controller.qtyController.text),
                                  price: double.parse(
                                      controller.priceController.text),
                                  priority: controller.priority);

                              var value = await controller.addItem(item);

                              if (value != 0)
                                controller.shoppingList.value.items?.add(item);
                            } else {
                              item!.itemName =
                                  controller.nameFieldController.text;
                              item!.description =
                                  controller.descriptionController.text;
                              item!.qty =
                                  int.parse(controller.qtyController.text);
                              item!.price =
                                  double.parse(controller.priceController.text);
                              item!.priority = controller.priority;

                              var value = await controller
                                  .updateItem(item as ShoppinglistItem);
                            }

                            Navigator.of(context).pop();
                          }),
                      SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              );
            })
          ]);
        });
  }
}
