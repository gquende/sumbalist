import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/mixins/localization_mixin.dart';
import 'package:sumbalist/utils/currency.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/shopping_list_controller.dart';
import '../../core/configs/app_locale.dart';
import '../../core/di/dependecy_injection.dart';
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

class _ShoplistDetailsState extends State<ShoplistDetails>
    with LocalizationMixin {
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
    return ListenableBuilder(
        listenable: Listenable.merge([DI.get<AppLocale>()]),
        builder: (_, __) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.shoppingList.name,
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              elevation: 0,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: size.height * 0.13,

                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          return Container(
                            height: size.height * 0.8,
                            width: size.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  controller.shoppingList.value.items!.isEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: SizedBox(
                                            width: size.width,
                                            height: size.height / 1.5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: SvgPicture.asset(
                                                    AppAssets.ADD_NOTE_IMAGE,
                                                    width: size.width / 2,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  strings.noItemListToBuy,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  strings.addItemAndBuy,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),

                                          ),
                                        )
                                      : Column(
                                          children: List.generate(
                                              controller.shoppingList.value
                                                      .items!.length ??
                                                  0,
                                              (index) => Dismissible(
                                                    key: UniqueKey(),
                                                    onDismissed: (direction) {
                                                      if (direction ==
                                                          DismissDirection
                                                              .endToStart) {
                                                        controller
                                                            .removeItem(controller
                                                                .shoppingList
                                                                .value
                                                                .items![index])
                                                            .then((value) {
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        setState(() {});

                                                      }
                                                    },
                                                    background: Container(
                                                      width: size.width,
                                                      color: Colors.transparent,
                                                    ),
                                                    secondaryBackground:
                                                        Container(
                                                      width: size.width,
                                                      color: Colors.red,
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        18.0),
                                                            child: Icon(
                                                              Icons.delete,
                                                              size: 26,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          right: size.width *
                                                              0.036),

                                                      child:
                                                          _shoppinglistItemWidget(
                                                              item: controller
                                                                  .shoppingList
                                                                  .value
                                                                  .items![index],
                                                              index: index),
                                                    ),
                                                  ))),
                                  controller.shoppingList.value.items!.length >
                                          7
                                      ? SizedBox(
                                          height: 80,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          );
                        })),
                  ),
                  Positioned(
                      child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 7.8,

                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            strings.completed,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Medium',
                                              fontSize: 16,
                                            ),
                                            // style: Text(),
                                          ),
                                          Text(
                                            "${AppCurrencyFormat.format(controller.shoppingList.value.calculateTotalBuyed())} (${controller.shoppingList.value.calculateTotalItemBuyed()})",
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Medium',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            strings.remaining,

                                            style: TextStyle(
                                                fontFamily: 'Poppins-Medium',
                                                fontSize: 16,
                                                color: Colors.grey),
                                            // style: Text(),
                                          ),
                                          Text(
                                            "    ${AppCurrencyFormat.format(controller.shoppingList.value.calculateTotal() - controller.shoppingList.value.calculateTotalBuyed())} (${controller.shoppingList.value.calculateTotalItemPending()})",
                                            style: TextStyle(
                                                fontFamily: 'Poppins-Medium',
                                                fontSize: 18,
                                                color: Colors.grey),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,

                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                        width: (size.width - 20),
                                        height: 20,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Color(0xff67727d)
                                                .withOpacity(0.1)),
                                      ),
                                      Container(
                                        width: (size.width - 20) *
                                            controller.shoppingList.value
                                                .getPercentBuyedByItem() /
                                            100,
                                        height: 20,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: PRIMARYCOLOR),
                                      ),
                                      Positioned(
                                          left: (size.width - 30) / 2,
                                          child: Text(
                                              "${(controller.shoppingList.value.getPercentBuyedByItem()).round()} %"))
                                    ],
                                  )
                                ],
                              ))),
                    ],
                  )),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Get.bottomSheet(
                  bottomSheet(null) as Widget,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ).then((value) {
                  setState(() {});
                });
              },
              child: Icon(Icons.add),
              backgroundColor: PRIMARYCOLOR,
            ),
          );
        });
  }

  Widget _shoppinglistItemWidget(
      {required ShoppinglistItem item, required int index}) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.093,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    Get.bottomSheet(
                      bottomSheet(item) as Widget,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ).then((value) {
                      setState(() {});
                    });
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
                        child: Icon(
                          Icons.shopping_cart,
                          color: SECONDARYCOLOR,
                        ),
                      ),
                      const SizedBox(
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
                          // SizedBox(
                          //   height: size.height * 0.002,
                          // ),
                          Text(
                            item.description,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          // SizedBox(
                          //   height: size.height * 0.006,
                          // ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppCurrencyFormat.format(
                                      item.price * item.qty),
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
            top: size.width * 0.11,
            child: Container(
              height: size.height * 0.03,
              width: size.width * 0.245,
              padding: EdgeInsets.only(left: 0, right: 0, bottom: 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (item.qty > 1) {
                        item.qty--;
                        controller.updateItem(item).then((value) {
                          // setState(() {});
                        });

                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          )),
                      child: const Text(
                        "-",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                  ),
                  Text(
                    "${item.qty}",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
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
                          borderRadius: const BorderRadius.only(
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
            )),
        Positioned(
            left: size.width / 1.16,
            top: -3,
            child: Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.red,
              ),
              child: Checkbox(
                value: item.isDone,
                onChanged: (value) {
                  item.isDone = value!;
                  controller.updateItem(item).then((value) {
                    setState(() {
                      _reorderItem(index);
                      controller.shoppingList.refresh();

                      if (controller.shoppingList.value
                              .getPercentBuyedByItem() ==
                          100.0) {
                        controller.shoppingList.value.statusUUID = "completed";
                        controller
                            .updateShoppinglist(controller.shoppingList.value)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(strings.doneList),
                            backgroundColor: Colors.green,
                          ));
                        });
                      } else {
                        controller.shoppingList.value.statusUUID =
                            'not completed';
                        controller
                            .updateShoppinglist(controller.shoppingList.value);
                      }
                    });
                  });
                },
                side: BorderSide(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.8),
                    width: 2),
              ),
            ))
      ],
    );
  }

  Widget bottomSheet(ShoppinglistItem? item) {
    var size = MediaQuery.of(context).size;

    var priority = 1.obs;
    var categoryIdSelected = 1.obs;

    final CurrencyTextInputFormatter inputCurrencyFormat =
        CurrencyTextInputFormatter.currency(
            symbol: AppCurrencyFormat.formater.value.symbol);

    if (item != null) {
      controller.nameFieldController.text = item!.itemName;
      controller.descriptionController.text = item!.description;
      controller.qtyController.text = "${item!.qty}";
      controller.priceController.text = "${item!.price.round()}";
      controller.priority = item!.priority;
      priority.value = item!.priority;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(strings.name),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 55,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controller.nameFieldController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.rectangle_stack,
                      ),
                      hintText: "",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strings.price),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width / 2.5,
                      height: 55,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: controller.priceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon:
                                  Icon(CupertinoIcons.money_dollar_circle),
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
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              labelStyle: TextStyle(color: Color(0xff000000)),
                              border: OutlineInputBorder()),
                          inputFormatters: [inputCurrencyFormat],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(strings.quantity),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: size.width / 2.5,
                      height: 55,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: controller.qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.number),
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
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              labelStyle: TextStyle(color: Color(0xff000000)),
                              border: OutlineInputBorder()),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(strings.description),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 55,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: controller.descriptionController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.square_list,
                      ),
                      hintText: "",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff)),
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      fillColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      labelStyle: TextStyle(color: Color(0xff000000)),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CommonButton(
                active: true,
                title: Text(
                  item == null ? strings.add : strings.update,
                  style: TextStyle(color: SECONDARYCOLOR),
                ),
                action: () async {
                  if (controller.validateForm(context)) {
                    if (item == null) {
                      var uuid = Uuid();

                      ShoppinglistItem item = ShoppinglistItem(
                          uuid: uuid.v4(),
                          isDone: false,
                          listUUID: widget.shoppingList.uuid,
                          itemName: controller.nameFieldController.text,
                          description: controller.descriptionController.text,
                          qty: int.parse(controller.qtyController.text),
                          price: double.parse(
                              "${inputCurrencyFormat.getUnformattedValue()}"),
                          priority: controller.priority);

                      var value = await controller.addItem(item);

                      if (value != 0) {
                        //Adiciona item na view
                        controller.shoppingList.value.items?.add(item);

                        //Actualiza o estado lista
                        controller.shoppingList.value.statusUUID =
                            'not completed';
                        controller
                            .updateShoppinglist(controller.shoppingList.value);
                      }
                    } else {
                      item.itemName = controller.nameFieldController.text;
                      item.description = controller.descriptionController.text;
                      item.qty = int.parse(controller.qtyController.text);
                      item.price = double.parse(
                          "${inputCurrencyFormat.getUnformattedValue()}");
                      item.priority = controller.priority;
                      controller.updateItem(item as ShoppinglistItem);
                    }

                    Navigator.of(context).pop();
                  }
                }),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _reorderItem(int oldIndex) {
    debugPrint("Index: $oldIndex");

    if (controller.shoppingList.value.items![oldIndex].isDone) {
      ShoppinglistItem? removedItem =
          controller.shoppingList.value.items!.removeAt(oldIndex);
      debugPrint("Index: $oldIndex");

      int newIndex = controller.shoppingList.value.items!
          .indexWhere((item) => item.isDone);
      if (newIndex == -1) {
        newIndex = controller.shoppingList.value.items!.length;
      }
      setState(() {
        controller.shoppingList.value.items!.insert(newIndex, removedItem);
      });
    } else {
      ShoppinglistItem? removedItem =
          controller.shoppingList.value.items!.removeAt(oldIndex);
      debugPrint("Index: $oldIndex");

      int newIndex = controller.shoppingList.value.items!
          .indexWhere((item) => item.isDone);
      if (newIndex == -1) {
        newIndex = controller.shoppingList.value.items!.length;
      }
      setState(() {
        controller.shoppingList.value.items!.insert(newIndex, removedItem);
      });
    }
  }

  Widget _buildItem(
      ShoppinglistItem item, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: _shoppinglistItemWidget(item: item, index: index),
    );
  }
}
