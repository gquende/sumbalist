import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sumbalist/mixins/localization_mixin.dart';
import 'package:sumbalist/pages/home/home.dart';
import 'package:sumbalist/pages/widgets/common_button.dart';

import '../utils/constants/files.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with LocalizationMixin {
  PageController pageController = PageController();

  int currentIndex = 0;
  int read = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width,
            height: size.height / 2,
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  width: size.width,
                  height: size.height / 2.5,
                  child: Column(
                    children: [
                      Container(
                          width: size.width,
                          height: size.height / 3,
                          child: Lottie.asset(AppAnimations.PLANNING_LIST)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                strings.planYourShoppingList,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                strings.theSecretToEfficient,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height / 2.5,
                  child: Column(
                    children: [
                      Container(
                          width: size.width,
                          height: size.height / 3,
                          child: Lottie.asset(AppAnimations.CHECK_LIST)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                strings.efficientShoppingList,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                strings.makeYourGroceryShoppingAnEfficient,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Container(
                  width: size.width,
                  height: size.height / 2.5,
                  child: Column(
                    children: [
                      Container(
                          width: size.width,
                          height: size.height / 3,
                          child: Lottie.asset(AppAnimations.SHOPPING)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                strings.beHappy,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                strings.beHappyWithSumbalist,
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  if (index == 2) {
                    read = index;
                  }
                });
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildDots(),
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CommonButton(
                title: Text(
                  strings.toContinue,
                  style: const TextStyle(color: Colors.black),
                ),
                active: read >= 2,
                action: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
                }),
          )
        ],
      ),
    );
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          3,
          (index) => AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: currentIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              height: 7,
              width: currentIndex == index ? 30 : 7,
              duration: const Duration(milliseconds: 150))),
    );
  }
}
