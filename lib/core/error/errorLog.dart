import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void errorLog(Object error, StackTrace stackTrace) {
  final frames = stackTrace.toString().split("\n");
  final frame = frames[0];
  debugPrint(
      "${frame.substring(0, frame.indexOf("(") - 1)}:: ${error.toString()}");
}

void devLog(Object log) {
  if (kDebugMode) {
    print(log);
  }
}
