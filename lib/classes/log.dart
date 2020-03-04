class Log {
  bool _value;
  DateTime _dateTime;

  Log(bool value) {
    _value = value;
    _dateTime = DateTime.now();
  }

  bool get value => _value;

  set value(bool value) {
    _value = value;
  }

  DateTime get dateTime => _dateTime;
}
