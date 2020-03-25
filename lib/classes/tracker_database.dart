import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tracker.dart';

class TrackerDatabase {
  static const String _databaseName = 'counter';
  Future<Database> _database;

  // Initializes the member variable '_database'.
  //
  // This function has to be called with 'await databaseObject.initDatabase()'
  // before any of the member functions are called!
  // TODO: rename to setUpDatabase
  Future<void> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._database = openDatabase(
      join(await getDatabasesPath(), 'counter_database.db'),
      onCreate: (db, version) {
        const command = "CREATE TABLE IF NOT EXISTS $_databaseName(name VARCHAR(128) PRIMARY KEY, type VARCHAR(128))";
        return db.execute(command);
      },
      version: 1,
    );
  }

  // Inserts a tracker object into the database
  Future<void> insertTracker(Tracker tracker) async {
    final Database db = await _database;

    await db.insert(
      _databaseName,
      tracker.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateTracker(Tracker tracker) async {
    final Database db = await _database;

    await db.update(
      _databaseName,
      tracker.toMap(),
      where: "name = ?",
      whereArgs: [tracker.name],
    );
  }

//  // A method that retrieves all the dogs from the dogs table.
//  Future<List<Tracker>> readTrackers() async {
//    final Database db = await _database;
//
//    final List<Map<String, dynamic>> maps = await db.query(_databaseName);
//
//    // Convert the List<Map<String, dynamic> into a List<Tracker>.
//    return List.generate(maps.length, (i) {
//      return Tracker(
//        name: maps[i]['name'],
//        type: maps[i]['type'],
//      );
//    });
//  }

//  // TODO: return value of counter with a given ID
//  Future<String> readCounterValue() async {
//    var trackerList = await readTrackers();
//    return trackerList[0].name;
//  }
}
