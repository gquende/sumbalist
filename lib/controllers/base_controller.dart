import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  errorLog2(String functionName, Object error) {
    debugPrint(
        "${this.runtimeType.toString()}::$functionName::${error.toString()}");
  }
}
