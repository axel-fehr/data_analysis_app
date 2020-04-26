class Log {
  bool _value;
  DateTime _timeStamp;

  Log(bool value, {DateTime timeStamp}) {
    _value = value;
    _timeStamp = timeStamp ?? DateTime.now();
  }

  bool get value => _value;
  DateTime get timeStamp => _timeStamp;
  String get valueAsYesOrNo => _value ? 'Yes' : 'No';

  set value(bool value) {
    _value = value;
  }

  static String boolToYesOrNo(bool value) {
    return value ? 'Yes' : 'No';
  }

  static bool yesOrNoToBool(String value) {
    if(value == 'Yes' || value == 'yes') {
      return true;
    }
    else if (value == 'No' || value == 'no') {
      return false;
    }
    else {
      throw('Given string cannot be converted to a Boolean log value');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'timeStamp' : _timeStamp.toIso8601String(),
      'value' : _value,
    };
  }

  @override
  String toString() {
    return 'Log{timeStamp: ${_timeStamp.toIso8601String()}, value: $_value}';
  }
}
