import 'package:flutter/foundation.dart';

class Log {
  bool _value;
  String _dateTime;

  bool get value => _value;

  set value(bool value) {
    _value = value;
  }

  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }
}