import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/controllers/login_controller.dart';
import 'package:sumbalist/mocks/mocks.dart';
import 'package:sumbalist/models/users.dart';

main() {
  var controller = LoginController();
  User user = userMock;

  setUp(() async {});

  test("Login", () {
    controller.usernameFieldController.value.text = "926884947";
    controller.passwordFieldController.value.text = "123456";
    expect(user.username, controller.usernameFieldController);
  });
}
