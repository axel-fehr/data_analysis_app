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

  Future<String> loadTrackersFromDisk() async {
//    await _trackerDatabase.initDatabase();
    _trackerDatabase.initDatabase().then((onValue) => 'Data loaded.');
  }

  void addTracker(String trackerName) async {
    Tracker trackerToAdd = Tracker(trackerName, 'Boolean'); // TODO: make tracker type a non-hard coded argument here
    _trackers.add(trackerToAdd);
    _trackerNames.add(trackerName);
    _trackerDatabase.insertTracker(trackerToAdd);
    notifyListeners();
  }
}
