import 'package:flutter/material.dart';

import '../classes/tracker.dart';
import '../classes/tracker_database.dart';

class TrackerList with ChangeNotifier {
  List<Tracker> _trackers = <Tracker>[];
  List<String> _trackerNames = <String>[];
  final TrackerDatabase _trackerDatabase = TrackerDatabase();

  List<Tracker> get trackers {
    return [..._trackers];
  }

  List<String> get trackerNames {
    return [..._trackerNames];
  }

  /// Initializes the list of trackers with the ones saved to disk.
  ///
  /// This function has to be called before any other member functions
  /// are called!
  Future<String> loadTrackersFromDisk() async {
    await _trackerDatabase.initDatabase();
    _trackers = await _trackerDatabase.readTrackers();
    _trackers.forEach((tracker) async => await tracker.loadLogsFromDisk());
    _trackerNames = await _trackerDatabase.readTrackerNames();
    return 'Data loaded.';
  }

  void addTracker(String trackerName) async {
    Tracker trackerToAdd = Tracker(trackerName, 'Boolean'); // TODO: make tracker type a non-hard coded argument here
    _trackers.add(trackerToAdd);
    _trackerNames.add(trackerName);
    notifyListeners();
    await _trackerDatabase.insertTracker(trackerToAdd);
    await trackerToAdd.loadLogsFromDisk(); // TODO: does this even make sense? The logs don't have to be loaded when a new tracker is created, right?
    // TODO: does this really work as expected,, since the return type is not Future<void>? does the function really fully execute the last line?
    // TODO: IS THIS FUNCTION EVEN EXECUTED SYNCHRONOUSLY OR ASYNCHRONOUSLY? BECAUSE IT DOES NOT RETURN A FUTURE BUT USES THE ASYNC KEYWORD
  }

  /// Changes the value of a log of a tracker with a given name, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker: the tracker the log that is going to be modified belongs to
  /// timeStampOfLogToChange: unique time stamp of the log whose value is going
  ///                         to be changed
  /// newLogValue: value that the log will have after the change
  void changeLogValue(Tracker tracker, DateTime timeStampOfLogToChange, bool newLogValue)
  {
    tracker.changeLogValue(timeStampOfLogToChange, newLogValue);
    notifyListeners();
  }

  /// Deletes the log of a tracker with a given name, notifies all
  /// listeners and saves the changes to disk.
  ///
  /// Arguments:
  /// tracker: the tracker the log that is going to be deleted belongs to
  /// timeStampOfLogToDelete: unique time stamp of the log that is going to be
  ///                         deleted
  void deleteLog(Tracker tracker, DateTime timeStampOfLogToDelete)
  {
    tracker.deleteLog(timeStampOfLogToDelete);
    notifyListeners();
  }
}
