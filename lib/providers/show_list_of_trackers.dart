import 'package:flutter/foundation.dart';

class ShowListOfTrackers with ChangeNotifier {
  bool _show;



  ShowListOfTrackers({@required bool show}) : _show = show;

  bool get show {
    return _show;
  }

  // TODO: remove this and make the setter below work
//  void setShow(bool value) {
//    _show = value;
//    notifyListeners();
//  }

  // TODO: what does the hint here mean?
  set show(bool value) {
    _show = value;
  }

  void toggleShow() {
    _show = !_show;
    notifyListeners();
  }
}
