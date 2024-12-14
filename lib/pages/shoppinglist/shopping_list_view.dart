import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../controllers/shopping_list_controller.dart';
import '../../core/configs/app_locale.dart';
import '../../core/di/dependecy_injection.dart';
import '../../mixins/localization_mixin.dart';
import 'components/shoppinglist_card.dart';
import '../../utils/constants/files.dart';

class ShoppingListView extends StatefulWidget {
  const ShoppingListView({super.key});

  @override
  State<ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<ShoppingListView>
    with LocalizationMixin {
  TextEditingController search = TextEditingController();
  ShoppingListController controller =
      GetIt.instance.get<ShoppingListController>();

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ListenableBuilder(
        listenable: Listenable.merge([DI.get<AppLocale>()]),
        builder: (_, __) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 30),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      controller.allShoppingList.isNotEmpty
                          ? Text(
                              strings.myList,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w600),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 30,
                      ),
                      controller.allShoppingList.isEmpty
                          ? SizedBox(
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
                                    strings.whatAreYouGoingToBuyToday,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    strings.createAListAndFollowUp,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(
                                  controller.allShoppingList.value.length,
                                  (index) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: ShoppingListCard(controller
                                            .allShoppingList.value[index]),
                                      )),
                            ),
                    ],
                  );
                }),
              ),
            ),
          );
        });
  }
}
