import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../../../utils/theme/theme.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      height: size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.monetization_on_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Moeda")
                  ],
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
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.checklist),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Listas concluídas")
                  ],
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
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondaryContainer),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.color_lens),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Modo escuro"),
                      ],
                    ),
                    Container(
                      child: LiteRollingSwitch(
                        //initial value
                        value: AppTheme.isDarkMode.value,
                        textOn: 'On',
                        textOff: 'Off',
                        colorOn: Colors.green,
                        colorOff: Colors.redAccent,
                        iconOn: Icons.done,
                        iconOff: Icons.remove_circle_outline,
                        textSize: 10.0,
                        onChanged: (bool state) {
                          //Use it to manage the different states
                          print('Current State of SWITCH IS: $state');
                        },
                        onTap: () {
                          AppTheme.setDarkMode(!AppTheme.isDarkMode.value);
                        },
                        onDoubleTap: () {},
                        onSwipe: () {}, width: 80,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
