import 'package:flutter/material.dart';

import '../classes/tracker.dart';
import '../classes/tracker_database.dart';
import '../classes/log.dart';

class TrackerList with ChangeNotifier {
  List<Tracker> _trackers;
  List<String> _trackerNames;
  final TrackerDatabase _trackerDatabase = TrackerDatabase();

  List<Tracker> get trackers {
    return [..._trackers];
  }

  List<String> get trackerNames {
    return [..._trackerNames];
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
        _trackerDatabase.initDatabase().then((onValueInitDataBase) {
      Future<List> innerLoadLogsFutures =
          _trackerDatabase.readTrackers().then((onValueLoadTrackers) {
        _trackers = onValueLoadTrackers;
        _trackerNames =
            List.generate(_trackers.length, (i) => _trackers[i].name);

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

  void addTracker(String trackerName) async {
    // TODO: make tracker type a non-hard coded argument here
    Tracker trackerToAdd =
        Tracker(trackerName, 'Boolean', initializeWithEmptyLogList: true);
    _trackers.add(trackerToAdd);
    _trackerNames.add(trackerName);
    notifyListeners();
    await _trackerDatabase.insertTracker(trackerToAdd);
    await trackerToAdd.setUpLogDatabase();
    // TODO: does this really work as expected,, since the return type is not Future<void>? does the function really fully execute the last line?
    // TODO: IS THIS FUNCTION EVEN EXECUTED SYNCHRONOUSLY OR ASYNCHRONOUSLY? BECAUSE IT DOES NOT RETURN A FUTURE BUT USES THE ASYNC KEYWORD
  }

  void removeTracker(Tracker trackerToRemove) async {
    _trackerNames.remove(trackerToRemove.name);
    _trackers.remove(trackerToRemove);
    notifyListeners();
    await _trackerDatabase.deleteTracker(trackerToRemove);
    await trackerToRemove.deleteLogDatabase();
    // TODO: does this really work as expected,, since the return type is not Future<void>? does the function really fully execute the last line?
    // TODO: IS THIS FUNCTION EVEN EXECUTED SYNCHRONOUSLY OR ASYNCHRONOUSLY? BECAUSE IT DOES NOT RETURN A FUTURE BUT USES THE ASYNC KEYWORD
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
  /// tracker: the tracker the log that is going to be deleted belongs to
  /// timeStampOfLogToDelete: unique time stamp of the log that is going to be
  ///                         deleted
  void deleteLog(Tracker tracker, DateTime timeStampOfLogToDelete) {
    tracker.deleteLog(timeStampOfLogToDelete);
    notifyListeners();
  }

  /// Adds a log to the tracker with the given name, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker: the tracker that the log will be added to
  /// logToAdd: the log that will be added
  void addLog(Tracker tracker, Log logToAdd) {
    tracker.addLog(logToAdd);
    notifyListeners();
  }
}
