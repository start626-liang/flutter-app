import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'essay-mode.dart';
import '../init-sql.dart' as Init;

Future<void> insert(Essay essagy, Database db) async {
  db.insert(
    Init.essayTatle,
    essagy.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<void> update(Essay essagy, Database db) async {
  await db.update(
    Init.essayTatle,
    essagy.toMap(),
    where: "id = ?",
    whereArgs: [essagy.id],
  );
}

Future<List<Essay>> selectAll(Database db) async {
  //  (查询数据表，获取所有的数据)
  final List<Map<String, dynamic>> maps = await db.query(Init.essayTatle);

  print('${Init.essayTatle}数据库数据数量：${maps.length}');
  return List.generate(maps.length, (i) {
    return Essay(
      id: maps[i]['id'],
      text: maps[i]['text'],
      directory: maps[i]['directory'],
      time: maps[i]['time'],
    );
  });
}

Future<Essay> select(Database db, int id) async {
  final List<Map<String, dynamic>> maps = await db.query(
    Init.essayTatle, // 使用 `where` 语句删除指定的数据
    where: "id = ?",
    // 通过 `whereArg` 将 id 传递给 `delete` 方法，以防止 SQL 注入
    whereArgs: [id],
  );

  if (1 == maps.length) {
    return Essay(
      id: maps[0]['id'],
      text: maps[0]['text'],
      directory: maps[0]['directory'],
      time: maps[0]['time'],
    );
  } else {
    throw FormatException('数据库数据异常，有两条!!!');
  }
}

Future<void> deleteEssay(Database db, int id) async {
  // Remove the Dog from the Database.
  await db.delete(
    Init.essayTatle,
    // 使用 `where` 语句删除指定的数据
    where: "id = ?",
    // 通过 `whereArg` 将 id 传递给 `delete` 方法，以防止 SQL 注入
    whereArgs: [id],
  );
}
