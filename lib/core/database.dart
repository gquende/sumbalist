import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  /// Versão do esquema local.
  ///
  /// **Ao alterar o esquema, incrementa-se isto e acrescenta-se um bloco em
  /// [migrate].** Até à versão 2 a base de dados não tinha `onUpgrade`: o
  /// esquema estava congelado na versão 1, e qualquer coluna nova rebentava
  /// para quem já tivesse a app instalada, porque a tabela antiga continuava lá
  /// sem ela.
  ///
  /// Histórico:
  /// - 1: esquema inicial.
  /// - 2: `currencyCode` em `shopping_lists` — moeda própria de cada lista.
  static const int schemaVersion = 2;

  final String _userTable = "users";
  final String _statusTable = "statuses";
  final String _shoppingListTable = "shopping_lists";
  final String _shoppingListItemTable = "shopping_list_items";
  final String _listCategoryTable = "list_categories";

  //String urlDatabase;

  Database? db;

  // AppDatabase({required this.urlDatabase}) {
  //  // open(urlDatabase);
  // }

  Future<Database?> open(String path) async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(inMemoryDatabasePath,
          options: OpenDatabaseOptions(
            version: schemaVersion,
            onCreate: (Database db, int version) async {
              await createTables(db, path);
            },
            onUpgrade: migrate,
          ));
    } else {
      db = await openDatabase(
        path,
        version: schemaVersion,
        onCreate: (Database db, int version) async {
          await createTables(db, path);
        },
        onUpgrade: migrate,
      );
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
              currencyCode TEXT,
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

  /// Leva uma base de dados existente da versão [from] até à [to].
  ///
  /// Os blocos são encadeados por número de versão e não por `else if`: quem
  /// saltar várias versões de uma vez (por exemplo, quem não abre a app há
  /// muito tempo) passa por todos os passos pela ordem certa.
  Future<void> migrate(Database db, int from, int to) async {
    if (from < 2) {
      // Nulo significa "herda a moeda do utilizador". As listas que já existem
      // ficam com nulo, portanto não mudam de comportamento.
      await db.execute(
        'ALTER TABLE $_shoppingListTable ADD COLUMN currencyCode TEXT',
      );
    }
  }

  Future close() async => db!.close();
}
