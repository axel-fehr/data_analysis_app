/// Log class with a generic type T that is a placeholder for the log type (e.g.
/// bool, int or float). T must be specified.
class Log<T> {
  T _value;
  DateTime _timeStamp;

  Log(T value, {DateTime timeStamp}) {
    assert(T != dynamic, 'The generic type of a log must not be dynamic.');

    _value = value;
    _timeStamp = timeStamp ?? DateTime.now();
  }

  T get value => _value;
  DateTime get timeStamp => _timeStamp;

  set value(T value) {
    _value = value;
  }

  /// Meant to be used to cast Log<dynamic> to Log<T>, where T is the runtime
  /// type of the log's value (e.g. bool, int or float).
  static Log castDynamicTypeLogToSpecificType(Log log) {
    switch (log.value.runtimeType) {
      case bool:
        return Log<bool>(log.value, timeStamp: log.timeStamp);
      case int:
        return Log<int>(log.value, timeStamp: log.timeStamp);
      case double:
        return Log<double>(log.value, timeStamp: log.timeStamp);
      default:
        throw ArgumentError('Unexpected log type: ${log.value.runtimeType}');
    }
  }

  static String boolToYesOrNo(bool value) {
    return value ? 'Yes' : 'No';
  }

  static bool yesOrNoToBool(String value) {
    if (value == 'Yes' || value == 'yes') {
      return true;
    } else if (value == 'No' || value == 'no') {
      return false;
    } else {
      throw ArgumentError(
          'Given string cannot be converted to a Boolean log value');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'timeStamp': _timeStamp.toIso8601String(),
      'value': _value,
    };
  }

  @override
  String toString() {
    return 'Log{timeStamp: ${_timeStamp.toIso8601String()}, value: $_value}';
  }
}
