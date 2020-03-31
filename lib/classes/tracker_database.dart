import 'dart:async';
import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tracker.dart';

/// Provides a database of trackers (names and types, not their logs),
/// and functions needed to store, manipulate and read entries.
class TrackerDatabase {
  static const String _databaseName = 'trackers';
  Future<Database> _database;

  /// Initializes the member variable '_database'.
  ///
  /// This function has to be called with 'await databaseObject.initDatabase()'
  /// before any other member functions are called! This is because this
  /// function is essential but cannot be executed in the constructor because
  /// it is asynchronous.
  // TODO: rename to setUpDatabase
  Future<void> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = openDatabase(
      join(await getDatabasesPath(), 'tracker_database.db'),
      onCreate: (db, version) {
        String command = 'CREATE TABLE IF NOT EXISTS $_databaseName(name VARCHAR(128) PRIMARY KEY, type VARCHAR(128))';
        return db.execute(command);
      },
      version: 1,
    );
  }

  /// Inserts a tracker object into the database
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
      where: 'name = ?',
      whereArgs: [tracker.name],
    );
  }

  /// Retrieves all the tracker names from the tracker table.
  Future<List<String>> readTrackerNames() async {
    final Database db = await _database;

    final List<Map<String, dynamic>> maps = await db.query(_databaseName);

    return List.generate(maps.length, (i) {
      return maps[i]['name'];
    });
  }

  /// Retrieves all the trackers from the tracker table.
  Future<List<Tracker>> readTrackers() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(_databaseName);

    // Convert the List<Map<String, dynamic> into a List<Tracker>.
    return List.generate(maps.length, (i) {
      return Tracker(
        maps[i]['name'],
        maps[i]['type'],
      );
    });
  }
}
