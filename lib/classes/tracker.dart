import './log.dart';
import './logs_storage.dart';

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

//  void addLog(bool logValue) {
//    print("adding log, value: $logValue");
//    _logs.add(Log(logValue));
//    var fileWithLog = _logStorage.writeLog(logValue);
//  }

  Future<File> addLog(bool logValue) {
    print("adding log, value: $logValue");
    _logs.add(Log(logValue));
    return _logStorage.writeLog(logValue);
  }
}
