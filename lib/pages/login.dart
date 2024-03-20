import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sumbalist/controllers/login_controller.dart';
import 'package:sumbalist/pages/signup/signup.dart';

import '../models/users.dart';
import '../utils/constants/app_colors.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 50.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bem vindo",
                        style: TextStyle(fontSize: size.height / 26),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam interdum, arcu vel euismod fermentum, sapien lectus ullamcorper arcu",
                          maxLines: 3,
                        ),
                        width: size.width,
                        height: size.height / 6,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xffe5e5e5),
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            controller:
                                controller.usernameFieldController.value,
                            decoration: InputDecoration(
                                hintText: "Nome de utilizador",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                prefixIcon: Icon(
                                  CupertinoIcons.person,
                                  color: Color(0xff000000),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(11))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
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
                          child: TextFormField(
                            controller:
                                controller.passwordFieldController.value,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Palavra passe",
                                contentPadding: EdgeInsets.only(bottom: 10),
                                focusColor: Color(0xff000000),
                                filled: true,
                                prefixIcon: Icon(
                                  CupertinoIcons.padlock,
                                  color: Color(0xff000000),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                fillColor: Color(0xffe5e5e5),
                                labelStyle: TextStyle(color: Color(0xff000000)),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(onTap: () async {
                        debugPrint("Clicked on Login");

                        User.logged = await controller.loginAccount(context);

                        if (User.logged != null) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                        }
                      }, child: Obx(() {
                        return Container(
                          width: size.width,
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: PRIMARYCOLOR,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: controller.loading.value
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          SECONDARYCOLOR),
                                    )
                                  : Text("Entrar")),
                        );
                      })),
                      /*  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint("Clicked on Forget Password...");
                    },
                    child: Text(
                      "Esqueceu a senha?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),*/
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width / 3.5,
                            child: Divider(
                              height: 4,
                              thickness: 1.5,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Entrar com"),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: size.width / 3.5,
                            child: Divider(
                              height: 4,
                              thickness: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              debugPrint("Clicked on login with Google");
                              var user = await controller.loginWithGoogle();
                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => Home()));
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Icon(
                                MdiIcons.google,
                                size: 40,
                                color: Color(0xff4285F4),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              debugPrint("Clicked on login with Facebook");
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.facebook,
                                size: 40,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ainda não tem uma conta? "),
                          GestureDetector(
                            onTap: () {
                              debugPrint("Clicked on Register...");

                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => Signup()));
                            },
                            child: Text(
                              "Registar-se ",
                              style: TextStyle(color: PRIMARYCOLOR),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
