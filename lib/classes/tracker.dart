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

  /// Changes the value of a log and saves the changes to disk.
  ///
  /// Arguments:
  /// timeStampOfLogToChange: unique time stamp of the log whose value is going
  ///                         to be changed
  /// newLogValue: value that the log will have after the change
  void changeLogValue(DateTime timeStampOfLogToChange, bool newLogValue) {

    print('\n\nIn changeLogValue...');
    print('\ngiven timestamp: $timeStampOfLogToChange');
    print('\nstored logs before update');
    _logs.forEach((log) => print('${log.value}, ${log.timeStamp}'));


    Log matchingLog = _logs.singleWhere(
            (log) => log.timeStamp == timeStampOfLogToChange,
        orElse: () =>
        throw ('No log found that matches the given time stamp.'));

    print('\nmatching log: ${matchingLog.value}, ${matchingLog.timeStamp}');

    matchingLog.value = newLogValue;
    _logDatabase.updateLog((matchingLog));
  }

  /// Deletes a log and saves the changes to disk.
  ///
  /// Arguments:
  /// timeStampOfLogToDelete: unique time stamp of the log that is going
  ///                         to be deleted
  void deleteLog(DateTime timeStampOfLogToDelete) {
    print('\ndeleting log.');
    print('passed time stamp: $timeStampOfLogToDelete');
    print('\ntime stamps of logs:');
    logs.forEach((log) => print(log.timeStamp));
    _logs.removeWhere((log) => log.timeStamp == timeStampOfLogToDelete);
    print('\ntime stamps of logs after deletion:');
    logs.forEach((log) => print(log.timeStamp));
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
