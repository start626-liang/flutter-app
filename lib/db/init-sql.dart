import 'package:sqflite/sqflite.dart';

final String imageTatle = 'image';
final String essayTatle = 'essay';
final String travelTatle = 'travel';

void init(Database db) {
  db.execute(
    "CREATE TABLE IF NOT EXISTS $essayTatle(id INTEGER PRIMARY KEY, text TEXT, directory INTEGER, time TEXT)",
  );
  db.execute(
    "CREATE TABLE IF NOT EXISTS $imageTatle(id INTEGER PRIMARY KEY,  directory INTEGER, file_name INTEGER, time TEXT)",
  );
  db.execute(
      'CREATE TABLE IF NOT EXISTS $travelTatle(id INTEGER PRIMARY KEY, title TEXT, site TEXT, startTimeMilliseconds INTEGER, endTimeMilliseconds INTEGER, time TEXT)');
}
