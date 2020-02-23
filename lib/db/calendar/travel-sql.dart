import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'travel-mode.dart';
import '../init-sql.dart' as Init;

Future<int> insert(Travel travel, Database db) async {
  return db.insert(
    Init.travelTatle,
    travel.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<List<Travel>> selectAll(Database db) async {
  //  (查询数据表，获取所有的数据)
  final List<Map<String, dynamic>> maps = await db.query(Init.travelTatle);

  print('${Init.travelTatle}数据库数据数量：${maps.length}');
  return List.generate(maps.length, (i) {
    return Travel(
      id: maps[i]['id'],
      title: maps[i]['title'],
      site: maps[i]['site'],
      startTimeMilliseconds: maps[i]['startTimeMilliseconds'],
      endTimeMilliseconds: maps[i]['endTimeMilliseconds'],
      time: maps[i]['time'],
    );
  });
}

Future<Travel> select(Database db, int id) async {
  final List<Map<String, dynamic>> maps = await db.query(
    Init.travelTatle, // 使用 `where` 语句删除指定的数据
    where: "id = ?",
    // 通过 `whereArg` 将 id 传递给 `delete` 方法，以防止 SQL 注入
    whereArgs: [id],
  );

  if (1 == maps.length) {
    return Travel(
      id: maps[0]['id'],
      title: maps[0]['title'],
      site: maps[0]['site'],
      startTimeMilliseconds: maps[0]['startTimeMilliseconds'],
      endTimeMilliseconds: maps[0]['endTimeMilliseconds'],
      time: maps[0]['time'],
    );
  } else {
    throw FormatException('数据库数据异常，有两条!!!');
  }
}
