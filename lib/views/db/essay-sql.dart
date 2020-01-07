import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:test1/views/db/essay-mode.dart';

import './essay-mode.dart';
import './init-sql.dart' as Init;

final String dbName = 'essay_database.db';

Future<void> insert(Essay essagy, Database db) async {
  db.insert(
    Init.essayTatle,
    essagy.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
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
