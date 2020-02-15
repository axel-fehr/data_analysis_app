import 'package:flutter/material.dart';
import '../classes/tracker.dart';

class TrackerList with ChangeNotifier {
  List<Tracker> _trackers = <Tracker>[];
  List<String> _trackerNames = <String>[];

  List<Tracker> get trackers {
    return [..._trackers];
  }

  List<String> get trackerNames {
    return [..._trackerNames];
  }

  void addTracker(String trackerName) {
    _trackers.add(Tracker(trackerName, 'boolean')); // TODO: make tracker type a non-hard coded argument here
    _trackerNames.add(trackerName);
    notifyListeners();
  }
}
