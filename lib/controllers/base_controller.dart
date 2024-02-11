import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  errorLog(String functionName, Object error) {
    debugPrint(
        "${this.runtimeType.toString()}::$functionName::${error.toString()}");
  }
}
