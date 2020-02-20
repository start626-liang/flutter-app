import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'travel-mode.dart';
import '../init-sql.dart' as Init;

Future<void> insert(Travel travel, Database db) async {
  db.insert(
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
      startTime: maps[i]['startTime'],
      endTime: maps[i]['endTime'],
      time: maps[i]['time'],
    );
  });
}
