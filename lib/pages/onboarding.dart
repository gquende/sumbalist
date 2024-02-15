import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sumbalist/pages/widgets/common_button.dart';

import '../utils/constants/files.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
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
                          child: SvgPicture.asset(AppAssets.NO_DATA_IMAGE)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical",
                          style: TextStyle(fontSize: size.width / 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                          child: SvgPicture.asset(AppAssets.ADD_NOTE_IMAGE)),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical",
                          style: TextStyle(fontSize: size.width / 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CommonButton(
              title: "Continuar",
              action: () {
                debugPrint("Continue...");
              })
        ],
      ),
    );
  }
}
