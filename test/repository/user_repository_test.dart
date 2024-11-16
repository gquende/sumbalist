import 'package:flutter_test/flutter_test.dart';
import 'package:sumbalist/core/database.dart';
import 'package:sumbalist/models/users.dart';

import 'package:sumbalist/repository/user_repository.dart';

main() {
  UserRepository? repository;

  setUp(() async {
    AppDatabase appDatabase = await AppDatabase(urlDatabase: "app.db");
    await appDatabase.open("app.db");

    repository = UserRepository(appDatabase: appDatabase);
  });

  test("Create User", () async {
    var userId = await repository!.create(User(
        uuid: "124",
        username: "kubico",
        name: "kubico",
        surname: "GHosue",
        phoneNumber: '',
        status: "registered"));

    expect(userId, isNotNull);
  });
}
