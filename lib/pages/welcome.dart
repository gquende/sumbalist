import 'package:flutter/material.dart';
import 'package:sumbalist/pages/home.dart';
import '../utils/constants/app_colors.dart';
import 'login.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.5,
              child: Center(
                child: Text(
                  "SUMBALIST",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
            Text(
              "Bem vindo",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Tenha eficiência na gestão de sua casa",
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: size.width,
              height: 55,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.g_mobiledata,
                      size: 35,
                      color: PRIMARYCOLOR,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      "Entrar com google",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
                style: TextButton.styleFrom(backgroundColor: THIRDCOLOR),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: size.width,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white)),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Criar conta",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
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
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: THIRDCOLOR),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
