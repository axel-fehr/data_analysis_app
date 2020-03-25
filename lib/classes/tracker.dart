import './log.dart';

class Tracker {
  String _name;
  String _type;
  List<Log> _logs = [];
//  LogsStorage _logStorage; // TODO: initialize object with name of file with the stored logs, name will be based on tracker name

  Tracker(String name, String type) {
    _name = name;
    _type = type;
//    _logStorage = LogsStorage();
  }

  String get type => _type;
  String get name => _name;
  List<Log> get logs => _logs;

  void addLog(bool logValue) {
    print("adding log, value: $logValue");
    _logs.add(Log(logValue));
//    _logStorage.writeLog(logValue);
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : _name,
      'type': _type,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Tracker{name: $_name, type: $_type}';
  }
}
