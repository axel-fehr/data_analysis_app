import 'package:flutter/material.dart';

//import './product.dart'; TODO: import other class here that provides a single tracker! (should improve performance a lot!)

class TrackerList with ChangeNotifier {
  static final _listTextStyle = TextStyle(fontSize: 30.0);
  List<Text> _trackers = <Text>[];

  List<Text> get trackers {
    return [..._trackers];
  }

  void addTracker(String trackerName) {
    _trackers.add(Text(trackerName, style: _listTextStyle));
    notifyListeners();
  }
}
