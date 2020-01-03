import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:test1/views/db/essay-mode.dart';

import './essay-mode.dart';

final String dbName = 'doggie_database.db';
final String tatleName = 'dogs';

Future<void> insert(Essay essagy, Database db) async {
  // Insert the Dog into the correct table. Also specify the
  // `conflictAlgorithm`. In this case, if the same dog is inserted
  // multiple times, it replaces the previous data.
  // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
  // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
  await db.insert(
    'dogs',
    essagy.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<List<Essay>> selectAll(Database db) async {
  // Query the table for all The Dogs (查询数据表，获取所有的狗狗们)
  final List<Map<String, dynamic>> maps = await db.query(tatleName);

  // Convert the List<Map<String, dynamic> into a List<Dog> (将 List<Map<String, dynamic> 转换成 List<Dog> 数据类型)
  print('数据库数据数量：${maps.length}');
  return List.generate(maps.length, (i) {
    return Essay(
      id: maps[i]['id'],
      text: maps[i]['text'],
      directory: maps[i]['directory'],
      time: maps[i]['time'],
    );
  });
}

Future<Database> createDB() async {
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    // 设置数据库的路径。注意：使用 `path` 包中的 `join` 方法是
    // 确保在多平台上路径都正确的最佳实践。
    path.join(await getDatabasesPath(), dbName),
    // When the database is first created, create a table to store dogs.
    // 当数据库第一次被创建的时候，创建一个数据表，用以存储狗狗们的数据。
    onCreate: (db, version) {
      print(2222);
      return db.execute(
        "CREATE TABLE IF NOT EXISTS $tatleName(id INTEGER PRIMARY KEY, text TEXT, directory TEXT, time TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    // 设置版本。它将执行 onCreate 方法，同时提供数据库升级和降级的路径。
    version: 1,
  );
}
