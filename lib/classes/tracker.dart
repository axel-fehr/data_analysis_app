import './log.dart';
import './log_database.dart';

class Tracker {
  final String _name;
  final String _type;
  List<Log> _logs;
  LogDatabase _logDatabase;

  Tracker(this._name, this._type, {initializeWithEmptyLogList = false}) {
    _logDatabase = LogDatabase(_name);

    if(initializeWithEmptyLogList) {
      _logs = [];
    }
  }

  Future<List<Log>> loadLogsFromDisk() async {
    await setUpLogDatabase();
    _logs = await _logDatabase.readLogs();
    return _logs;
  }

  Future<void> setUpLogDatabase() async {
    await _logDatabase.setUpDatabase();
  }

  Future<void> deleteLogDatabase() async {
    await _logDatabase.deleteDatabaseFromDisk();
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

  /// Changes the value of a log and saves the changes to disk.
  ///
  /// Arguments:
  /// timeStampOfLogToChange: unique time stamp of the log whose value is going
  ///                         to be changed
  /// newLogValue: value that the log will have after the change
  void changeLogValue(DateTime timeStampOfLogToChange, bool newLogValue) {
    Log matchingLog = _logs.singleWhere(
        (log) => log.timeStamp == timeStampOfLogToChange,
        orElse: () =>
            throw ('No log found that matches the given time stamp.'));
    matchingLog.value = newLogValue;
    _logDatabase.updateLog((matchingLog));
  }

  /// Deletes a log and saves the changes to disk.
  ///
  /// Arguments:
  /// timeStampOfLogToDelete: unique time stamp of the log that is going
  ///                         to be deleted
  void deleteLog(DateTime timeStampOfLogToDelete) {
    _logs.removeWhere((log) => log.timeStamp == timeStampOfLogToDelete);
    _logDatabase.deleteLog((timeStampOfLogToDelete));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'type': _type,
    };
  }

  @override
  String toString() {
    return 'Tracker{name: $_name, type: $_type}';
  }
}
