import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../controllers/shopping_list_controller.dart';
import '../../../models/shopping_list_item.dart';
import '../../../utils/constants/app_colors.dart';

class ShoplistItemWidget extends StatefulWidget {
  ShoppinglistItem item;

  ShoplistItemWidget({required this.item});

  @override
  State<ShoplistItemWidget> createState() => _ShoplistItemWidgetState();
}

class _ShoplistItemWidgetState extends State<ShoplistItemWidget> {
  var controller = GetIt.instance.get<ShoppingListController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
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
                      widget.item.itemName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    SizedBox(
                      height: size.height * 0.006,
                    ),
                    Row(
                      children: [
                        Text("Qtd: ${widget.item.qty}"),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Preço: ${widget.item.price}'),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Prioride: ${widget.item.priority}')
                      ],
                    )
                  ],
                ),
              ],
            ),
            Checkbox(
              value: widget.item.isDone,
              onChanged: (value) {
                widget.item.isDone = value!;

                controller.updateItem(widget.item).then((value) {
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
    );
  }
}
