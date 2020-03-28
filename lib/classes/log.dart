class Log {
  bool _value;
  DateTime _timeStamp;

  Log(bool value, {DateTime timeStamp}) {
    _value = value;
    _timeStamp ??= DateTime.now();
  }

  bool get value => _value;

  set value(bool value) {
    _value = value;
  }

  DateTime get timeStamp => _timeStamp;

  Map<String, dynamic> toMap() {
    return {
      'timeStamp' : _timeStamp.toIso8601String(),
      'value' : _value,
    };
  }

  @override
  String toString() {
    return 'Tracker{timeStamp: ${_timeStamp.toIso8601String()}, value: $_value}';
  }
}
