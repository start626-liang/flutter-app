import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'image-mode.dart';
import '../init-sql.dart' as Init;

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
      maps[i]['directory'],
      maps[i]['fileName'],
      maps[i]['time'],
      id: maps[i]["id"],
    );
  });
}

Future<List<ImageDate>> selectDirectory(Database db, directory) async {
  final List<Map<String, dynamic>> maps = await db
      .query(Init.imageTatle, where: "directory = ?", whereArgs: [directory]);

  print('${Init.imageTatle}数据库数据数量：${maps.length}');
  return List.generate(maps.length, (i) {
    return ImageDate(
      maps[i]['directory'],
      maps[i]['fileName'],
      maps[i]['time'],
      id: maps[i]["id"],
    );
  });
}

Future<void> deleteImageID(Database db, int id) async {
  await db.delete(
    Init.imageTatle,
    // 使用 `where` 语句删除指定的数据
    where: "id = ?",
    // 通过 `whereArg` 将 参数 传递给 `delete` 方法，以防止 SQL 注入
    whereArgs: [id],
  );
}

Future<void> deleteImageDirectory(Database db, int directory) async {
  await db.delete(
    Init.imageTatle,
    // 使用 `where` 语句删除指定的数据
    where: "directory = ?",
    // 通过 `whereArg` 将 参数 传递给 `delete` 方法，以防止 SQL 注入
    whereArgs: [directory],
  );
}
