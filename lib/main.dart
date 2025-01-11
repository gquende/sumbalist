import 'package:flutter/material.dart';

import 'app.dart';
import 'core/configs/setup_app.dart';

void main() async {
  await setupApp();

  runApp(App(
    isDarkMode: false,
  ));

 // runApp(TEST2());
}


class TEST2 extends StatefulWidget {
  const TEST2({super.key});

  @override
  State<TEST2> createState() => _TEST2State();
}

class _TEST2State extends State<TEST2> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(appBar: AppBar(title: Text("TEST"),),),);
  }
}
