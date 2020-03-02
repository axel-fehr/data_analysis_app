import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import './log.dart';
import './logs_storage.dart';

class Tracker {
  String _name;
  String _type;
  List<Log> _logs = [];
  LogsStorage _logStorage; // TODO: initialize object with name of file with the stored logs, name will be based on tracker name

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
    _logStorage.writeCounter(logValue);
  }
}
