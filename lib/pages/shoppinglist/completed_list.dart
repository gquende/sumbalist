import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sumbalist/controllers/shopping_list_controller.dart';
import '../../utils/constants/files.dart';
import 'components/shoppinglist_card.dart';

class CompletedShoppingList extends StatefulWidget {
  const CompletedShoppingList({super.key});

  @override
  State<CompletedShoppingList> createState() => _CompletedShoppingListState();

}

class _CompletedShoppingListState extends State<CompletedShoppingList> {
  var controller = GetIt.instance.get<ShoppingListController>();

  @override
  Widget build(BuildContext context) {
    context.watch<ShoppingListController>();

    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text("Listas concluídas"),
          centerTitle: true,
        ),
        body: Container(
            width: size.width,
            height: size.height,
            child: FutureBuilder(
                future: controller.getAllShoppingList(status: ' completed'),
                builder: (ctx, snap) {
                  if (!snap.hasData && controller.isLoading.value == true) {
                    return SizedBox(
                      height: size.height / 4,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  var data = snap.data ?? [];

                  if (data.isEmpty) {
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
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Sem lista concluída",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                          data.length,
                          (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: ShoppingListCard(data[index]),
                              )),
                    ),
                  );
                })));
  }
}
