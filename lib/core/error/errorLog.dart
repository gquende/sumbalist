import 'package:flutter/cupertino.dart';

void errorLog(Object error, StackTrace stackTrace) {
  final frames = stackTrace.toString().split("\n");
  final frame = frames[0];
  debugPrint(
      "${frame.substring(0, frame.indexOf("(") - 1)}:: ${error.toString()}");
}
