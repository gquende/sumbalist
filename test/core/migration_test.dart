import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sumbalist/core/database.dart';

/// O esquema da versão 1, tal como estava antes de existirem migrações.
const String _v1ShoppingLists = '''
  create table shopping_lists(
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
''';

void main() {
  late Directory tempDir;
  late String dbPath;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sumbalist_migration');
    dbPath = '${tempDir.path}/sumbalist.db';
  });

  tearDown(() async {
    if (tempDir.existsSync()) await tempDir.delete(recursive: true);
  });

  /// Cria uma base de dados na versão 1 com uma lista lá dentro, como a de
  /// alguém que já tem a app instalada.
  Future<void> seedVersion1() async {
    final db = await databaseFactoryFfi.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) => db.execute(_v1ShoppingLists),
      ),
    );

    await db.insert('shopping_lists', {
      'uuid': 'lista-1',
      'userUUID': 'utilizador-1',
      'categoryUUID': '0',
      'name': 'Compras do mês',
      'total': 0.0,
      'statusUUID': 'not completed',
    });

    await db.close();
  }

  Future<Database> openCurrent() {
    return databaseFactoryFfi.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: AppDatabase.schemaVersion,
        onUpgrade: AppDatabase().migrate,
      ),
    );
  }

  group('migração da versão 1 para a atual', () {
    test('não perde as listas que já existiam', () async {
      await seedVersion1();

      final db = await openCurrent();
      final rows = await db.query('shopping_lists');

      expect(rows, hasLength(1));
      expect(rows.first['name'], 'Compras do mês');
      expect(rows.first['uuid'], 'lista-1');

      await db.close();
    });

    test('acrescenta currencyCode a nulo, ou seja, a herdar', () async {
      await seedVersion1();

      final db = await openCurrent();
      final rows = await db.query('shopping_lists');

      expect(
        rows.first.containsKey('currencyCode'),
        isTrue,
        reason: 'a coluna nova não foi criada na migração',
      );
      expect(
        rows.first['currencyCode'],
        isNull,
        reason: 'listas antigas têm de continuar a seguir a moeda do '
            'utilizador, não ficar presas a uma',
      );

      await db.close();
    });

    test('a coluna aceita um código depois de migrada', () async {
      await seedVersion1();

      final db = await openCurrent();
      await db.update(
        'shopping_lists',
        {'currencyCode': 'EUR'},
        where: 'uuid = ?',
        whereArgs: ['lista-1'],
      );

      final rows = await db.query('shopping_lists');
      expect(rows.first['currencyCode'], 'EUR');

      await db.close();
    });

    test('correr de novo não repete a migração', () async {
      await seedVersion1();

      // Abrir, fechar e voltar a abrir: a segunda abertura já está na versão
      // atual, por isso `onUpgrade` não corre. Se corresse, o ALTER TABLE
      // falhava com "duplicate column".
      var db = await openCurrent();
      await db.close();

      db = await openCurrent();
      final rows = await db.query('shopping_lists');

      expect(rows, hasLength(1));
      await db.close();
    });
  });
}
