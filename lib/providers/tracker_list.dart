import 'package:flutter/material.dart';
import '../classes/tracker.dart';
import '../classes/tracker_database.dart';

class TrackerList with ChangeNotifier {
  List<Tracker> _trackers = <Tracker>[];
  List<String> _trackerNames = <String>[];
  TrackerDatabase _trackerDatabase = new TrackerDatabase();
  // TODO: rename trackerDatabase to something that makes it clearer that the database just contains the names

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
    // TODO: does this really work as expected,, since the return type is not Future<void>? does the function really fully execute the last line?
    // TODO: IS THIS FUNCTION EVEN EXECUTED SYNCHRONOUSLY OR ASYNCHRONOUSLY? BECAUSE IT DOES NOT RETURN A FUTURE BUT USES THE ASYNC KEYWORD
  }
}
