import './log.dart';
import './log_database.dart';
import '../enumerations/tracker_type.dart';

/// Stores a list of logs of the given type T (T is a generic type and must be
/// specified) and provides an interface to manipulate them.
class Tracker<T> {
  String _name;
  final Type _logType = T;
  List<Log<T>> _logs;
  LogDatabase _logDatabase;

  /// Creates a tracker object.
  ///
  /// Arguments:
  /// name -- the name of the tracker
  /// logs -- a list of Logs the tracker has (must be null
  ///         if [initializeWithEmptyLogList == true])
  /// initializeWithEmptyLogList -- whether to initialize the object with an
  ///                               empty list of logs (must be false if a list
  ///                               of logs is given)
  Tracker(this._name,
      {List<Log<T>> logs, bool initializeWithEmptyLogList = false}) {
    _logDatabase = LogDatabase<T>(_name);

    assert(T != dynamic, 'The generic type of a tracker must not be dynamic.');

    if (initializeWithEmptyLogList && logs == null) {
      _logs = [];
    } else if (logs != null && !initializeWithEmptyLogList) {
      _logs = logs;
    } else if (logs != null && initializeWithEmptyLogList) {
      throw ArgumentError('Do not pass a list of logs to the constructor when '
          '[initializeWithEmptyLogList] is true');
    }
  }

  Type get logType => _logType;
  String get name => _name;
  List<Log<T>> get logs => _logs;

  Future<List<Log<T>>> loadLogsFromDisk() async {
    await setUpLogDatabase();
    List<Log<T>> loadedLogs = await _logDatabase.readLogs().then(
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
    int compareLogTimeStamps(Log<T> log1, Log<T> log2) {
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

  void addLog(Log<T> logToAdd) {
    _logs.add(logToAdd);
    _logDatabase.insertLog(logToAdd);
  }

  /// Changes the value of a log and saves the changes to disk.
  ///
  /// Arguments:
  /// timeStampOfLogToChange: unique time stamp of the log whose value is going
  ///                         to be changed
  /// newLogValue: value that the log will have after the change
  void changeLogValue(DateTime timeStampOfLogToChange, T newLogValue) {
    Log<T> matchingLog = _logs.singleWhere(
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

  @override
  String toString() {
    return 'Tracker{name: $_name, log type: $_logType}';
  }
}
