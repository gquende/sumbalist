import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  Function action;
  // String title;
  bool active = true;
  Widget title;

  CommonButton(
      {super.key,
      required this.title,
      required this.action,
      required this.active});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return TextButton(
      style: active
          ? Theme.of(context).textButtonTheme.style
          : TextButton.styleFrom(backgroundColor: Colors.grey),
      onPressed: () {
        if (active) {
          action();
        }
      },
      child: Container(
        width: size.width,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Padding(padding: const EdgeInsets.all(10), child: title),
      ),
    );
  }
}
