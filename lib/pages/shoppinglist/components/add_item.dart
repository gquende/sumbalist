import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sumbalist/mocks/item_category_mock.dart';
import 'package:sumbalist/models/item_list_category.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../models/shopping_list.dart';
import '../../../models/shopping_list_item.dart';
import '../../widgets/common_button.dart';

class AddItemBody extends StatefulWidget {
  ShoppingList list;
  ShoppinglistItem? item;

  AddItemBody({required this.list, this.item});

  @override
  State<AddItemBody> createState() => _AddItemBodyState();
}

class _AddItemBodyState extends State<AddItemBody> {
  //ShoppingListCategory? categorySelected = null;

  var priority = 1.obs;
  var categoryIdSelected = 1.obs;

  ShoppingListController controller =
      GetIt.instance.get<ShoppingListController>();

  List<ItemListCategory> categories = [];

  @override
  void initState() {
    // TODO: implement initState

    categories = itemListCategoriesMock;

    if (widget.item != null) {
      controller.nameFieldController.text = widget.item!.itemName;
      controller.descriptionController.text = widget.item!.description;
      controller.qtyController.text = "${widget.item!.qty}";
      controller.priceController.text = "${widget.item!.price}";
      controller.priority = widget.item!.priority;
      priority.value = widget.item!.priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Wrap(
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
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
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
                  decoration: const InputDecoration(
                      hintText: "",
                      contentPadding: EdgeInsets.only(bottom: 10),
                      focusColor: Color(0xff000000),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
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
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
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
                          borderRadius: BorderRadius.all(Radius.circular(11))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(11))),
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
                title: Text(widget.item == null ? "Adicionar" : "Actualizar"),
                action: () async {
                  if (widget.item == null) {
                    ShoppinglistItem item = ShoppinglistItem(
                        uuid: Uuid().v4(),
                        isDone: false,
                        listUUID: widget.list.uuid,
                        itemName: controller.nameFieldController.text,
                        description: controller.descriptionController.text,
                        qty: int.parse(controller.qtyController.text),
                        price: double.parse(controller.priceController.text),
                        priority: controller.priority);

                    var value = await controller.addItem(item);

                    if (value != 0) {
                      // controller.shoppingList.value.items?.add(item);
                    }
                  } else {
                    widget.item!.itemName = controller.nameFieldController.text;
                    widget.item!.description =
                        controller.descriptionController.text;
                    widget.item!.qty = int.parse(controller.qtyController.text);
                    widget.item!.price =
                        double.parse(controller.priceController.text);
                    widget.item!.priority = controller.priority;

                    // var value = await controller
                    //     .updateItem(widget.item as ShoppinglistItem);
                  }

                  //  Navigator.of(context).pop();
                })
          ],
        ));
  }

  Widget ItemCategoryIcon(
      bool active, ItemListCategory category, BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: active ? Color.fromRGBO(253, 185, 19, 0.1) : Color(0xffF9F9F9),
          border: active
              ? Border.all(color: Theme.of(context).primaryColor)
              : null),
      child: Icon(
        category.icon,
        color: active ? Theme.of(context).primaryColor : Color(0xff9C9C9C),
      ),
    );
  }
}
