import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './log.dart';

/// A log database that stores logs of the given type T (T is a generic type and
/// must be specified).
class LogDatabase<T> {
  String _trackerName;
  String _tableNameInDoubleQuotationMarks;
  String _databasePath;
  Future<Database> _database;

  /// Instantiates an instance of the class.
  ///
  /// Arguments:
  /// [_trackerName] : the name of the tracker whose logs are stored in
  ///                  the database.
  LogDatabase(this._trackerName) {
    assert(T != dynamic,
        'The generic type of a log database must not be dynamic.');

    // double quotation marks are used to handle names with spaces
    _tableNameInDoubleQuotationMarks =
        _getTableNameInDoubleQuotationMarks(_trackerName);
  }

  /// Returns the name of the table that stores the logs of a tracker with the
  /// given name. The name will be returned in double quotation marks.
  ///
  /// Double quotation marks are needed to handle tracker names with spaces in
  /// them.
  String _getTableNameInDoubleQuotationMarks(String trackerName) {
    return '"' + trackerName + '_logs' + '"';
  }

  /// Initializes the member variable [_database].
  ///
  /// The future this function returns has to be completed before any other
  /// member functions are called! This is because this function is essential
  /// but cannot be executed in the constructor because it is asynchronous.
  Future<void> setUpDatabase() async {
    _database = _createNewDatabase(_trackerName).then((Database db) {
      _databasePath = db.path;
      return db;
    });
  }

  Future<Database> _createNewDatabase(String trackerName) async {
    WidgetsFlutterBinding.ensureInitialized();
    String databasePath =
        join(await getDatabasesPath(), trackerName + '_log_database.db');
    String tableNameInDoubleQuotationMarks =
        _getTableNameInDoubleQuotationMarks(trackerName);
    Future<Database> database = openDatabase(
      databasePath,
      onCreate: (db, version) {
        // TODO: change this depending on T
        String command =
            'CREATE TABLE IF NOT EXISTS $tableNameInDoubleQuotationMarks('
            'timeStamp DATETIME PRIMARY KEY, '
            'value INTEGER)';
        return db.execute(command);
      },
      version: 1,
    );
    return database;
  }

  /// Updates the name of the tracker the database belongs to (only the
  /// instance variable in this class, not the name of tracker object) and
  /// changes the name of the database accordingly.
  ///
  /// This is needed because the name of the database includes the tracker name.
  /// So when the tracker name is changed, the name of the log database has to
  /// be changed to.
  void updateTrackerName(String newTrackerName) async {
    // create new DB with table
    Future<Database> newDBFuture = _createNewDatabase(newTrackerName);
    Database newDB = await newDBFuture;

    // copy data from old DB
    String oldDatabaseAlias = 'old_database';
    await newDB.rawQuery('ATTACH DATABASE "${_databasePath}" '
        'AS $oldDatabaseAlias');
    String newTableName = _getTableNameInDoubleQuotationMarks(newTrackerName);
    String copyLogTableCommand = 'INSERT INTO $newTableName '
        'SELECT * FROM '
        '$oldDatabaseAlias.$_tableNameInDoubleQuotationMarks';
    await newDB.execute(copyLogTableCommand).then(
      (value) async {
        await deleteDatabase(_databasePath); // delete old DB

        // update all fields
        _databasePath = newDB.path;
        _tableNameInDoubleQuotationMarks = newTableName;
        _trackerName = newTrackerName;
        _database = newDBFuture;
      },
    );
  }

  Future<void> deleteDatabaseFromDisk() async {
    await deleteDatabase(_databasePath);
    print('log database deleted.');
  }

  /// Inserts a log object into the database
  Future<void> insertLog(Log<T> log) async {
    final Database db = await _database;

    await db.insert(
      _tableNameInDoubleQuotationMarks,
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateLog(Log<T> log) async {
    final Database db = await _database;

    await db.update(
      _tableNameInDoubleQuotationMarks,
      log.toMap(),
      where: 'timeStamp = ?',
      whereArgs: [log.timeStamp.toIso8601String()],
    );
  }

  /// Deletes a log from the database.
  ///
  /// Arguments:
  /// timeStampOfLogToDelete -- time stamp of the log that will be deleted, the
  ///                           time stamp serves as a unique identifier
  Future<void> deleteLog(DateTime timeStampOfLogToDelete) async {
    final Database db = await _database;

    await db.delete(
      _tableNameInDoubleQuotationMarks,
      where: 'timeStamp = ?',
      whereArgs: [timeStampOfLogToDelete.toIso8601String()],
    );
  }

  /// Retrieves all the logs from the tracker table.
  Future<List<Log<T>>> readLogs() async {
    final Database db = await _database;

    final List<Map<String, dynamic>> maps =
        await db.query(_tableNameInDoubleQuotationMarks);

    // Convert the List<Map<String, dynamic> into a List<Log>.
    return List.generate(maps.length, (i) {
      var logValue;

      if (T == bool) {
        logValue = _mapIntLogValueFromDatabaseToBool(maps[i]['value']);
      } else if (T == int || T == double) {
        logValue = maps[i]['value'];
      } else {
        throw ('Unexpected value for the generic type: $T');
      }

      return Log<T>(
        logValue,
        timeStamp: DateTime.parse(maps[i]['timeStamp']),
      );
    });
  }

  bool _mapIntLogValueFromDatabaseToBool(int logValueFromDatabase) {
    if (logValueFromDatabase == 0) {
      return false;
    } else if (logValueFromDatabase == 1) {
      return true;
    } else {
      throw ('Integers other than 0 and 1 are not converted to Booleans.');
    }
  }
}
