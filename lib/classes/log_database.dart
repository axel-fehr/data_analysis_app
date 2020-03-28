import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './log.dart';

class LogDatabase {
  final String _trackerName;
  final String _databaseName;
  Future<Database> _database;

  /// Instantiates an instance of the class.
  ///
  /// Arguments:
  /// [_trackerName] : the name of the tracker whose logs are stored in
  ///                  the database.
  LogDatabase(this._trackerName) : _databaseName = _trackerName + '_logs';

  /// Initializes the member variable [_database].
  ///
  /// This function has to be called with 'await databaseObject.setUpDatabase()'
  /// before any other member functions are called! This is because this
  /// function is essential but cannot be executed in the constructor because
  /// it is asynchronous.
  Future<void> setUpDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    this._database = openDatabase(
      join(await getDatabasesPath(), _trackerName + '_log_database.db'),
      onCreate: (db, version) {
        // TODO: adjust the type used to store values based on the type of tracker
        String command = "CREATE TABLE IF NOT EXISTS $_databaseName(timeStamp DATETIME PRIMARY KEY, value INTEGER)";
        return db.execute(command);
      },
      version: 1,
    );
  }

  /// Inserts a log object into the database
  Future<void> insertLog(Log log) async {
    final Database db = await _database;

    await db.insert(
      _databaseName,
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateLog(Log log) async {
    final Database db = await _database;

    await db.update(
      _databaseName,
      log.toMap(),
      where: "timeStamp = ?",
      whereArgs: [log.timeStamp],
    );
  }

  bool mapIntLogValueFromDatabaseToBool(int logValueFromDatabase) {
    if (logValueFromDatabase == 0) {
      return false;
    }
    else if (logValueFromDatabase == 1) {
      return true;
    }
    else {
      throw('Integers other than 0 and 1 are not converted to Booleans.');
    }
  }

  /// Retrieves all the logs from the tracker table.
  Future<List<Log>> readLogs() async {
    final Database db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(_databaseName);

    // Convert the List<Map<String, dynamic> into a List<Log>.
    return List.generate(maps.length, (i) {
      return Log(
        mapIntLogValueFromDatabaseToBool(maps[i]['value']), // TODO: FIX BUG CAUSED HERE BY TIMESTAMP THAT IS CREATED IN CONSTRUCTOR, USE ORIGINAL TIMESTAMP INSTEAD! LOAD TIMESTAMP THAT IS SAVED ALONG WITH THE VALUE HERE
      );
    });
  }
}
