import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tracking_app/global_variables.dart' as globals;
import '../classes/tracker.dart';
import '../classes/tracker_database.dart';
import '../classes/log.dart';

class TrackerList with ChangeNotifier {
  List<Tracker> _trackers;
  final TrackerDatabase _trackerDatabase = TrackerDatabase();

  List<Tracker> get trackers {
    return [..._trackers];
  }

  List<String> get trackerNames {
    return List.generate(_trackers.length, (index) => _trackers[index].name);
  }

  /// Initializes the list of trackers with the ones saved to disk.
  ///
  /// The list of futures returned by this function have to be completed before
  /// any other member functions are called!
  /// The returned list of futures only contains futures of the list of logs
  /// that are stored on disk but completing will complete other futures
  /// (e.g. setting up databases and initializing tracker names list) in the
  /// right order.
  Future<List> getFuturesToCompleteBeforeAppStart() {
    Future<List> loadLogsFutures =
        _trackerDatabase.initDatabase().then((Database onValueInitDataBase) {
      Future<List> innerLoadLogsFutures = _trackerDatabase
          .readTrackers()
          .then((List<Tracker> onValueLoadTrackers) {
        _trackers = onValueLoadTrackers;

        List<Future> loadLogsFutureList = [];
        _trackers.forEach((tracker) {
          Future<List<Log>> loadLogsFromDiskFuture = tracker.loadLogsFromDisk();
          loadLogsFutureList.add(loadLogsFromDiskFuture);
        });
        return Future.wait(loadLogsFutureList);
      });
      return innerLoadLogsFutures;
    });
    return loadLogsFutures;
  }

  void addTracker(Tracker trackerToAdd) async {
    _trackers.add(trackerToAdd);
    notifyListeners();

    // 1 is subtracted from the length to take into account that the tracker
    // was already added to [_trackers] above
    int listIndexOfAddedTracker = _trackers.length - 1;
    await _trackerDatabase.insertTracker(trackerToAdd,
        listIndex: listIndexOfAddedTracker);
    await trackerToAdd.setUpLogDatabase();
  }

  /// Renames a tracker and updates the database accordingly.
  ///
  /// Arguments:
  /// trackerName -- name of the tracker that is being renamed
  /// newTrackerName -- new name of the tracker
  void renameTracker(String trackerName, String newTrackerName) async {
    int indexOfTracker =
        _trackers.indexWhere((element) => element.name == trackerName);

    Tracker trackerToRename = _trackers[indexOfTracker];
    await _trackerDatabase.updateTrackerName(
        trackerToRename.name, newTrackerName);
    trackerToRename.rename(newTrackerName);
    notifyListeners();
  }

  void deleteTracker(Tracker trackerToRemove) async {
    int indexOfTrackerToRemove = _trackers.indexOf(trackerToRemove);
    _trackers.remove(trackerToRemove);
    notifyListeners();
    await _trackerDatabase.deleteTracker(trackerToRemove,
        listIndexOfTracker: indexOfTrackerToRemove);
    await trackerToRemove.deleteLogDatabase();
  }

  /// Changes the value of a log of a given tracker, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker: the tracker the log that is going to be modified belongs to
  /// timeStampOfLogToChange: unique time stamp of the log whose value is going
  ///                         to be changed
  /// newLogValue: value that the log will have after the change
  void changeLogValue(
      Tracker tracker, DateTime timeStampOfLogToChange, bool newLogValue) {
    tracker.changeLogValue(timeStampOfLogToChange, newLogValue);
    notifyListeners();
  }

  /// Deletes the log of a given tracker, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker -- the tracker the log that is going to be deleted belongs to
  /// timeStampOfLogToDelete -- unique time stamp of the log that is going to be
  ///                           deleted
  void deleteLog(Tracker tracker, DateTime timeStampOfLogToDelete) {
    tracker.deleteLog(timeStampOfLogToDelete);
    notifyListeners();
  }

  /// Adds a log to the tracker with the given name, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker -- the tracker that the log will be added to
  /// logToAdd -- the log that will be added
  void addLog(Tracker tracker, Log logToAdd) {
    tracker.addLog(Log.castDynamicTypeLogToSpecificType(logToAdd));
    tracker.sortLogsByDate();
    notifyListeners();
  }

  /// Changes the position of a tracker in the tracker list and database.
  ///
  /// Arguments:
  /// indexOfTracker -- index of the tracker in the tracker list whose position
  ///                   in the tracker list is going to be changed
  /// desiredIndexOfTracker -- index that the tracker should have in the tracker
  ///                          list
  void changePositionOfTracker(
      {@required int indexOfTracker, @required int desiredIndexOfTracker}) {
    if (desiredIndexOfTracker > indexOfTracker) {
      desiredIndexOfTracker -= 1;
    }
    final Tracker trackerToReposition = _trackers.removeAt(indexOfTracker);
    _trackers.insert(desiredIndexOfTracker, trackerToReposition);
    notifyListeners();

    _trackerDatabase.changePositionOfTracker(
        indexOfTracker: indexOfTracker,
        desiredIndexOfTracker: desiredIndexOfTracker);
  }
}
