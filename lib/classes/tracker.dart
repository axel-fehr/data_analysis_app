import 'package:flutter/foundation.dart';
import './log.dart';

class Tracker {
  String _type;
  String _name;
  List<Log> _logs = [];

  String get type => _type;
  String get name => _name;
  List<Log> get logs => _logs;

  void addLog(logValue) {
    _logs.add(Log(logValue));
  }
}
