import 'package:flutter/foundation.dart';

class ShowListOfTrackers with ChangeNotifier {
  bool _show;

  ShowListOfTrackers({@required bool show}) : _show = show;

  bool get show {
    return _show;
  }

  void setShow(bool input) {
    _show = input;
    notifyListeners();
  }

  void toggleShow() {
    _show = !_show;
    notifyListeners();
  }
}
