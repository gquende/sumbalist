import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/services/firebase_service.dart';

main() {
  test("", () async {
    await FirebaseService.getShoppingList("u5Y5lo0WoJWPISCwS44ok4yXQqs1");
  });
}
