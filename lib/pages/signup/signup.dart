import 'package:flutter/material.dart';
import 'package:sumbalist/controllers/signup_controller.dart';
import 'package:sumbalist/pages/signup/components/user_credentials.dart';
import 'package:sumbalist/pages/signup/components/user_info.dart';
import 'package:sumbalist/pages/signup/components/user_phone.dart';
import 'package:sumbalist/pages/widgets/common_button.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  PageController pageController = PageController();
  var controller = SignupController();

  int currentPage = 0;

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
                        currentPage--;

                        setState(() {});
                        pageController.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: currentPage > 1
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.arrow_back_ios),
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
                      controller: pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        UserInfo(context),
                        UserCredentials(context),
                        UserPhone(context)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonButton(
                      title: controller.isLoading.value
                          ? CircularProgressIndicator()
                          : Text(currentPage == 3 ? "Concluir" : "Avançar"),
                      action: () async {
                        if (currentPage < 3) {
                          currentPage++;
                        }
                        if (currentPage == 3) {
                          await controller.createAccount();
                        } else {
                          setState(() {});
                          pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        }
                      },
                      active: true)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
