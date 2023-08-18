import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //Function to create tables
  static Future<void> createTables(sql.Database db) async {
    //Table to store drink history info
    await db.execute('''CREATE TABLE drinks(
        type TEXT,
        abv REAL,
        oz REAL,
        datetime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      ''');

    //Table to persist current count/bac
    await db.execute('''CREATE TABLE info(
        count REAL,
        bac REAL
      )
      ''');
  }

  //Function to open database
  static Future<sql.Database> openDatabase() async {
    return sql.openDatabase(
      'history.db',
      version: 1,
      onCreate: (sql.Database db, int version) async {
        await createTables(db);
      },
    );
  }

  static Future<void> closeDatabase() async {
    final db = await SQLHelper.openDatabase();
    await db.close();
  }

  static Future<void> saveInfo(double count, double bac) async {
    final db = await SQLHelper.openDatabase();

    final data = {'count': count, 'bac': bac};
    final existingInfo = await db.query('info');

    if (existingInfo.isNotEmpty) {
      // Update existing data
      await db.update('info', data);
    } else {
      // Insert new data if no existing data found
      await db.insert('info', data);
    }
  }

  static Future<double> getCount() async {
    final db = await SQLHelper.openDatabase();
    final result = await db.query('info', columns: ['count'], limit: 1);

    if (result.isNotEmpty) {
      return result.first['count'] as double;
    } else {
      return 0.0; // No data found
    }
  }

  static Future<double> getBac() async {
    final db = await SQLHelper.openDatabase();
    final result = await db.query('info', columns: ['bac'], limit: 1);

    if (result.isNotEmpty) {
      return result.first['bac'] as double;
    } else {
      return 0.0; // No data found
    }
  }

  static Future<void> deleteInfo() async {
    final db = await SQLHelper.openDatabase();
    await db.delete('info');
  }

  //Plan is to persist count/bac so app will maintain info if closed
  //Save drink history upon restart and then allow previous dates drink history to be accessed
}
