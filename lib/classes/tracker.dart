import 'package:flutter/foundation.dart';
import './log.dart';

class Tracker {
  String _name;
  String _type;
  List<Log> _logs = [];

  Tracker(String name, String type) {
    _name = name;
    _type = type;
  }

  String get type => _type;
  String get name => _name;
  List<Log> get logs => _logs;

  void addLog(logValue) {
    print("adding log, value: $logValue");
    _logs.add(Log(logValue));
  }
}
