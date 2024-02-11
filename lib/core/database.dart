import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  final String _userTable = "users";
  final String _statusTable = "statuses";
  final String _shoppingListTable = "shopping_lists";
  final String _shoppingListItemTable = "shopping_list_items";

  final String _listCategoryTable = "list_categories";

  String urlDatabase;

  Database? db;

  AppDatabase({required this.urlDatabase}) {
    open(urlDatabase);
  }

  Future<Database?> open(String path) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
              version: 1,
              onCreate: (Database db, int version) async {
                await createTables(db, path);
              }));
    } else {
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await createTables(db, path);
      });
    }

    return db;
  }

  Future<void> createTables(Database db, String path) async {
    await db.execute('''
              create  table $_userTable( 
              id integer primary key autoincrement, 
              uuid TEXT,
              username TEXT,
              name TEXT,
              surname TEXT,
              password TEXT,
              created_at TEXT,
              updated_at TEXT
              )
        ''');

    await db.execute('''
              create  table $_listCategoryTable( 
              id integer primary key autoincrement, 
              uuid TEXT unique,
              name TEXT,
              create_at TEXT,
              updated_at TEXT
              )
        ''');

    await db.execute('''
              create  table $_shoppingListTable( 
              id integer primary key autoincrement, 
              uuid TEXT unique,
              userUUID TEXT,
              categoryUUID TEXT,
              name TEXT,
              total REAL,
              statusUUID TEXT,
              created_at TEXT,
              updated_at TEXT
              )
        ''');

    await db.execute('''
              create  table $_shoppingListItemTable( 
              id integer primary key autoincrement, 
              uuid TEXT unique,
              listUUID TEXT,
              itemName TEXT,
              description TEXT,
              qty integer,
              price double,
              priority integer,
              isDone integer
              statusUUID TEXT,
              created_at TEXT,
              updated_at TEXT
              )
        ''');

    await db.execute('''
              create  table $_statusTable( 
              id integer primary key autoincrement, 
              uuid TEXT unique,
              name TEXT,
              created_at TEXT,
              updated_at TEXT
              )
        ''');
  }

  Future close() async => db!.close();
}
