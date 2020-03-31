import './log.dart';
import './log_database.dart';

class Tracker {
  final String _name;
  final String _type;
  List<Log> _logs = [];
  LogDatabase _logDatabase;

  Tracker(this._name, this._type) {
    _logDatabase = LogDatabase(_name);
  }

  Future<String> loadLogsFromDisk() async {
    await _logDatabase.setUpDatabase();
    _logs = await _logDatabase.readLogs();
    return 'Data loaded.';
  }

  String get type => _type;
  String get name => _name;
  List<Log> get logs => _logs;

  void addLog(bool logValue) {
    print('adding log, value: $logValue');
    Log addedLog = Log(logValue);
    _logs.add(addedLog);
    _logDatabase.insertLog(addedLog);
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : _name,
      'type': _type,
    };
  }

  @override
  String toString() {
    return 'Tracker{name: $_name, type: $_type}';
  }
}
