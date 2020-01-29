import 'package:flutter/material.dart';
import '../classes/tracker.dart';

class TrackerList with ChangeNotifier {
  static final _listTextStyle = TextStyle(fontSize: 30.0);
  List<Text> _trackers = <Text>[];
  //TODO: use a list of tracker objects, each of which contains its logs etc.

  List<Text> get trackers {
    return [..._trackers];
  }

  void addTracker(String trackerName) {
    _trackers.add(Text(trackerName, style: _listTextStyle));
    notifyListeners();
  }
}
