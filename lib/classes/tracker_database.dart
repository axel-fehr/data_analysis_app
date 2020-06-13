import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tracking_app/global_variables.dart' as globals;
import '../enumerations/tracker_type.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tracker.dart';

/// Provides a database of trackers (names and types, not their logs),
/// and functions needed to store, manipulate and read entries.
class TrackerDatabase {
  static const String _tableName = 'trackers';
  Future<Database> _database;
  static const List<String> _databaseMigrationScripts = [
    // the following four queries serve to change the primary key column from
    // the name column to a new auto-incremented int column (to make renaming
    // possible) by creating a table with the desired structure and copying the
    // original data into it
    'CREATE TABLE table_copy('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name VARCHAR(64),'
        'type VARCHAR(32))',
    'INSERT INTO table_copy(name, type) SELECT name, type FROM $_tableName',
    'DROP TABLE $_tableName',
    'ALTER TABLE table_copy RENAME TO $_tableName',

    // the following two queries are used to add a list index column to a table
    // and fill it with 0..(n-1), where n is the number of trackers. This is
    // done to be able to store the order of the trackers chosen by the user.
    // Note: the default value of 0 is chosen because a non-null constant value
    // is needed to avoid causing an exception.
    'ALTER TABLE $_tableName ADD list_index INTEGER NOT NULL DEFAULT 0',
    'UPDATE $_tableName SET list_index = (SELECT COUNT(*) '
        'FROM $_tableName tableCopy '
        'WHERE $_tableName.id > tableCopy.id)',
  ];

  /// Initializes the member variable [_database].
  ///
  /// The future this function returns has to be completed before any other
  /// member functions are called! This is because this function is essential
  /// but cannot be executed in the constructor because it is asynchronous.
  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = openDatabase(
      join(await getDatabasesPath(), 'tracker_database.db'),
      onCreate: (db, version) async {
        /// Table columns:
        /// id -- used as primary key (using name as primary key makes renaming
        ///       difficult
        /// name -- name of the tracker
        /// type -- type of the tracker (e.g. Boolean, or Integer)
        /// list_index -- index that determines the position of the tracker in
        ///               the tracker list that is shown on the main screen
        ///               Note: the default value of 0 is chosen because a
        ///                     non-null constant value is needed to avoid
        ///                     causing an exception.
        String command = 'CREATE TABLE IF NOT EXISTS $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name VARCHAR(128) NOT NULL UNIQUE, '
            'type VARCHAR(128) NOT NULL, '
            'list_index INTEGER NOT NULL DEFAULT 0)';
        await db.execute(command);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion - 1; i < newVersion - 1; i++) {
          print('\nold version: $oldVersion, new version: $newVersion');
          await db.execute(_databaseMigrationScripts[i]);
        }
      },
      version: _databaseMigrationScripts.length + 1,
    );

    // return the Future so that the caller knows when it is completed
    return await _database;
  }

  /// Inserts a tracker object into the database
  Future<void> insertTracker(Tracker tracker, {@required int listIndex}) async {
    final Database db = await _database;

    assert(listIndex == await readTrackers().then((value) => value.length));

    String trackerTypeAsString = getTrackerTypeAsString(tracker);
    return db.rawInsert('INSERT INTO $_tableName(name, type, list_index) '
        'VALUES("${tracker.name}", "$trackerTypeAsString", $listIndex)');
  }

  /// Returns a string designating the type of the given tracker.
  ///
  /// The tracker type is inferred based on the log type of the given tracker.
  String getTrackerTypeAsString(Tracker tracker) {
    switch (tracker.logType) {
      case bool:
        return globals.yesNoTrackerType;
      case int:
        return globals.intTrackerType;
      case double:
        return globals.decimalTrackerType;
      default:
        throw ArgumentError('Unexpected log type "${tracker.logType}" could '
            'not be mapped to a known tracker type');
    }
  }

  Future<void> updateTrackerName(
      String oldTrackerName, String newTrackerName) async {
    final Database db = await _database;

    await db.rawUpdate('UPDATE $_tableName '
        'SET name = "$newTrackerName" '
        'WHERE name = "$oldTrackerName"');
  }

  Future<void> deleteTracker(Tracker trackerToDelete,
      {@required int listIndexOfTracker}) async {
    final Database db = await _database;

    await db.delete(
      _tableName,
      where: 'name = ?',
      whereArgs: [trackerToDelete.name],
    ).then((value) async {
      String updateOtherListIndices = 'UPDATE $_tableName '
          'SET list_index = list_index - 1 '
          'WHERE list_index > $listIndexOfTracker';
      await db.rawUpdate(updateOtherListIndices);
    });
  }

  /// Retrieves all the trackers from the tracker table.
  Future<List<Tracker>> readTrackers() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    // Convert the List<Map<String, dynamic> into a List<Tracker>.
    return List.generate(maps.length, (i) {
      // get the map where the tracker has the right list index (this is done
      // to return the trackers in the order determined by the way the user
      // ordered the tracker list on the main screen
      Map trackerMap = maps.singleWhere((map) => map['list_index'] == i);

      Type logType = mapTrackerTypeAsStringToLogType(trackerMap['type']);
      switch (logType) {
        case bool:
          return Tracker<bool>(trackerMap['name']);
        case int:
          return Tracker<int>(trackerMap['name']);
        case double:
          return Tracker<double>(trackerMap['name']);
        default:
          throw ('Unexpected log type: "$logType".');
      }
    });
  }

  /// Maps a given String that is expected to designate a tracker type to a
  /// concrete type that the logs of the tracker with the given type have.
  ///
  /// This method throws an ArgumentError if the given string does not contain
  /// known keywords that can be mapped to a concrete type.
  ///
  /// This method is used to ensure that the strings that designate the tracker
  /// types can still be mapped to log types even if these strings change over
  /// the course of development of were different in the past.
  Type mapTrackerTypeAsStringToLogType(String trackerTypeAsString) {
    // lowercase used to make the following check case insensitive
    trackerTypeAsString = trackerTypeAsString.toLowerCase();

    if (trackerTypeAsString.contains('binary') ||
        trackerTypeAsString.contains('boolean')) {
      return bool;
    } else if (trackerTypeAsString.contains('int') ||
        trackerTypeAsString.contains('integer')) {
      return int;
    } else if (trackerTypeAsString.contains('decimal') ||
        trackerTypeAsString.contains('double') ||
        trackerTypeAsString.contains('float')) {
      return double;
    } else if (trackerTypeAsString.contains('yes') &&
        trackerTypeAsString.contains('no')) {
      return bool;
    } else {
      throw ArgumentError(
          'Unexpected tracker type as string: "$trackerTypeAsString"');
    }
  }

  void changePositionOfTracker(
      {@required int indexOfTracker,
      @required int desiredIndexOfTracker}) async {
    if (indexOfTracker == desiredIndexOfTracker) {
      return;
    }

    final Database db = await _database;
    List<Tracker> currentTrackerList = await readTrackers();

    assert(desiredIndexOfTracker >= 0, 'Desired index must be >= 0.');
    assert(desiredIndexOfTracker < currentTrackerList.length,
        'Desired index must be less than the length of the tracker list.');

    Future<void> updateOtherIndices() async {
      if (desiredIndexOfTracker < indexOfTracker) {
        String updateIndices =
            'UPDATE $_tableName SET list_index = list_index + 1 '
            'WHERE list_index < $indexOfTracker '
            'AND list_index >= $desiredIndexOfTracker';
        await db.rawQuery(updateIndices);
      } else if (desiredIndexOfTracker > indexOfTracker) {
        String updateIndices =
            'UPDATE $_tableName SET list_index = list_index - 1 '
            'WHERE list_index > $indexOfTracker '
            'AND list_index <= $desiredIndexOfTracker';
        await db.rawQuery(updateIndices);
      }
    }

    String nameOfTracker = currentTrackerList[indexOfTracker].name;
    await updateOtherIndices().then((value) async {
      String setIndexOfTracker =
          'UPDATE $_tableName SET list_index = $desiredIndexOfTracker '
          'WHERE name = "$nameOfTracker"';
      await db.rawQuery(setIndexOfTracker);
    });
  }
}
