import 'dart:async';

import 'package:sqflite/sqflite.dart';

import './image-mode.dart';
import './init-sql.dart' as Init;

final String dbName = 'essay_database.db';

Future<void> insert(ImageDate image, Batch batch) async {
  batch.insert(
    Init.imageTatle,
    image.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
  //  rawInsert(
//      'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
}

Future<List<ImageDate>> selectAll(Database db) async {
  //  (查询数据表，获取所有的数据)
  final List<Map<String, dynamic>> maps = await db.query(Init.imageTatle);

  print('${Init.imageTatle}数据库数据数量：${maps.length}');
  return List.generate(maps.length, (i) {
    return ImageDate(
      id: maps[i]["id"],
      directory: maps[i]['directory'],
      file_name: maps[i]['file_name'],
      time: maps[i]['time'],
    );
  });
}
