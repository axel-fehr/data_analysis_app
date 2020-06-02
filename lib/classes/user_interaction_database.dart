import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../enumerations/user_interaction.dart';

/// Class for a database that stores values that indicate what interactions
/// with the app have already taken place. This is used to decide whether to
/// show additional information to the user to teach him how to use the app and
/// what it can do.
class UserInteractionDatabase {
  static const String _tableName = 'user_interactions';
  Future<Database> _database;
  Map<String, int> _databaseContent; // maps column name to content

  /// Initializes the member variable [_database] and [_databaseContent].
  ///
  /// The future this function returns has to be completed before any other
  /// member functions are called! This is because this function is essential
  /// but cannot be executed in the constructor because it is asynchronous.
  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = openDatabase(
      join(await getDatabasesPath(), 'user_interactions.db'),
      onCreate: (db, version) async {
        /// Table columns:
        /// created_tracker -- whether the user already created his first
        ///                    tracker or not
        /// added_log -- whether the user already added a log to a tracker
        ///              or not
        /// opened_log_analysis_route -- whether the user already opened the
        ///                              route that shows the log statistics of
        ///                              a tracker or not
        /// NOTE: All values are stored as integers: 1 --> true, 0 --> false
        String createTable = 'CREATE TABLE $_tableName('
            'created_tracker INTEGER, '
            'added_log INTEGER, '
            'opened_log_analysis_route INTEGER)';
        await db.execute(createTable).then((value) async {
          String addFirstRow = 'INSERT INTO $_tableName VALUES(0, 0, 0)';
          await db.execute(addFirstRow);
        });
      },
      version: 1,
    );

    // return a Future of the database that completes after [_databaseContent]
    // has been initialized
    return await _database;
  }

  /// Initializes [_databaseContent].
  ///
  /// [_databaseContent] cannot be initialized in the constructor because the
  /// initialization is asynchronous. So this function has to be called before
  /// [_databaseContent] is used.
  Future<Map<String,int>> initializeDatabaseContent() async {
    Map<String,int> databaseContent = await readUserInteractions();
    _databaseContent = databaseContent;
    return databaseContent;
  }

  /// Records that the given kind of user interaction has taken place (saved to
  /// disk).
  Future<void> recordUserInteraction(UserInteraction userInteraction) async {
    String tableColumnToUpdate =
        mapUserInteractionToColumnName(userInteraction);
    _databaseContent[tableColumnToUpdate] = 1;

    final Database db = await _database;
    await db.rawUpdate('UPDATE $_tableName '
        'SET $tableColumnToUpdate = 1');
  }

  /// Returns a Boolean value indicating whether the given type of user
  /// interaction has already been recorded or not (i.e. whether the given
  /// interaction has already happened).
  bool isRecorded(UserInteraction userInteraction) {
    String tableColumn = mapUserInteractionToColumnName(userInteraction);
    bool interactionAlreadyRecorded = _databaseContent[tableColumn] == 1;
    return interactionAlreadyRecorded;
  }

  /// Returns the column name of the table that stores whether the given user
  /// interaction has ever taken place or not.
  String mapUserInteractionToColumnName(UserInteraction userInteraction) {
    switch (userInteraction) {
      case UserInteraction.createdTracker:
        return 'created_tracker';
      case UserInteraction.addedLog:
        return 'added_log';
      case UserInteraction.openedLogAnalysisRoute:
        return 'opened_log_analysis_route';
      default:
        throw ArgumentError(
            'Not a recognized user interaction: $userInteraction.');
    }
  }

  /// Retrieves all the logs from the tracker table.
  Future<Map<String, int>> readUserInteractions() async {
    final Database db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    assert(maps.length == 1,
        'there is more than one row in the user interaction table');
    return Map.fromIterables(maps[0].keys, maps[0].values.cast<int>());
  }

  /// Maps the integers that are contained in the columns of the table to
  /// Boolean values (1 --> true, 0 --> false).
  bool mapIntValueFromColumnToBool(int logValueFromColumn) {
    if (logValueFromColumn == 0) {
      return false;
    } else if (logValueFromColumn == 1) {
      return true;
    } else {
      throw ArgumentError(
          'Integers other than 0 and 1 are not converted to Booleans.');
    }
  }
}
