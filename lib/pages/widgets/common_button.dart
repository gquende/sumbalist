import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class CommonButton extends StatelessWidget {
  Function action;
  String title;

  CommonButton({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return TextButton(
      style: Theme.of(context).textButtonTheme.style,
      onPressed: () => action(),
      child: Container(
        width: size.width,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: Padding(padding: const EdgeInsets.all(10), child: Text(title)),
      ),
    );
  }
}
