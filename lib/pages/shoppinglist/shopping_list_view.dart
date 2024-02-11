import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../constants/files.dart';
import '../../controllers/shopping_list_controller.dart';
import 'components/shoppinglist_card.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView> {
  TextEditingController search = TextEditingController();
  ShoppingListController controller =
      GetIt.instance.get<ShoppingListController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.getShoppingList();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lista de compras",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (controller.isLoading.value == false &&
                    controller.shoppinglist.value.isEmpty) {
                  return Container(
                    width: size.width,
                    height: size.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.NO_DATA_IMAGE,
                            width: size.width / 1.7,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "O que você precisa comprar hoje?",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Crie uma lista e rastreie",
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                      controller.shoppinglist.value.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ShoppingListCard(
                                controller.shoppinglist.value[index]),
                          )),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
