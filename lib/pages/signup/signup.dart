import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sumbalist/controllers/signup_controller.dart';
import 'package:sumbalist/pages/login.dart';
import 'package:sumbalist/pages/signup/components/user_credentials.dart';
import 'package:sumbalist/pages/signup/components/user_info.dart';
import 'package:sumbalist/pages/signup/components/user_phone.dart';
import 'package:sumbalist/pages/widgets/common_button.dart';
import 'package:sumbalist/utils/constants/app_colors.dart';

import '../policy_and_terms.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var controller = Get.put(SignupController());

  @override
  void dispose() {
    // TODO: implement dispose

    controller.cleanData();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 40),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (controller.currentPage > 0) {
                          setState(() {
                            controller.currentPage--;
                            controller.pageController.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });

                          //  controller.pageController.jumpToPage(controller.currentPage);
                        }
                      },
                      child: controller.currentPage >= 1
                          ? CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                ),
                              ),
                            )
                          : Container(
                              height: 40,
                            )),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  Container(
                    height: size.height / 2,
                    width: size.width,
                    child: PageView(
                      controller: controller.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        UserInfo(context),
                        UserCredentials(context),
                        UserPhone()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() => CommonButton(
                      title: controller.isLoading.value
                          ? Container(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.black),
                              ),
                            )
                          : Text(
                              controller.currentPage == 2
                                  ? "Concluir"
                                  : "Avançar",
                              style: TextStyle(color: SECONDARYCOLOR),
                            ),
                      action: () async {
                        controller.nextStep(context);

                        setState(() {});
                      },
                      active: true)),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PolicyAndTerms()));
                    },
                    child: RichText(
                      text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text:
                                  'Ao se registar você concorda com as nossas ',
                            ),
                            TextSpan(
                                text: 'Políticas de privacidade',
                                style: TextStyle(
                                  color: PRIMARYCOLOR,
                                )),
                            TextSpan(text: ' e ', style: TextStyle()),
                            TextSpan(
                                text: 'Termos de uso',
                                style: TextStyle(
                                  color: PRIMARYCOLOR,
                                ))
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Já tem uma conta?",
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => Login()),
                              (route) => false);
                        },
                        child: Text(
                          "Entrar",
                          style: TextStyle(color: PRIMARYCOLOR),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
