import './log.dart';
import './log_database.dart';

class Tracker {
  String _name;
  final String _type;
  List<Log> _logs;
  LogDatabase _logDatabase;

  /// Creates a tracker object.
  ///
  /// Arguments:
  /// name -- the name of the tracker
  /// type -- the tracker type (e.g. Boolean)
  /// logs -- a list of Logs the tracker has (must be null
  ///         if [initializeWithEmptyLogList == true])
  /// initializeWithEmptyLogList -- whether to initialize the object with an
  ///                               empty list of logs (must be false if a list
  ///                               of logs is given)
  Tracker(this._name, this._type,
      {List<Log> logs, bool initializeWithEmptyLogList = false}) {
    _logDatabase = LogDatabase(_name);

    if (initializeWithEmptyLogList && logs == null) {
      _logs = [];
    } else if (logs != null && !initializeWithEmptyLogList) {
      _logs = logs;
    } else if (logs != null && initializeWithEmptyLogList) {
      throw ArgumentError('Do not pass a list of logs to the constructor when '
          '[initializeWithEmptyLogList] is true');
    }
  }

  String get type => _type;
  String get name => _name;
  List<Log> get logs => _logs;

  Future<List<Log>> loadLogsFromDisk() async {
    await setUpLogDatabase();
    List<Log> loadedLogs = await _logDatabase.readLogs().then(
      (List<Log> onValue) {
        _logs = onValue;
        sortLogsByDate();
        return _logs;
      },
    );
    return loadedLogs;
  }

  /// Orders the log list of the tracker by date such that logs the most recent
  /// time stamps dates are before logs with later time stamp dates.
  void sortLogsByDate() {
    /// Comparator for logs.
    int compareLogTimeStamps(Log log1, Log log2) {
      return log1.timeStamp.compareTo(log2.timeStamp) * (-1);
    }

    _logs.sort(compareLogTimeStamps);
  }

  Future<void> setUpLogDatabase() async {
    await _logDatabase.setUpDatabase();
  }

  Future<void> deleteLogDatabase() async {
    await _logDatabase.deleteDatabaseFromDisk();
  }

  void addLog(Log logToAdd) {
    _logs.add(logToAdd);
    _logDatabase.insertLog(logToAdd);
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
  /// timeStampOfLogToDelete -- unique time stamp of the log that is going
  ///                           to be deleted
  void deleteLog(DateTime timeStampOfLogToDelete) {
    _logs.removeWhere((log) => log.timeStamp == timeStampOfLogToDelete);
    _logDatabase.deleteLog((timeStampOfLogToDelete));
  }

  void rename(String newName) {
    _name = newName;
    _logDatabase.updateTrackerName(newName);
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
