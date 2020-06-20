import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/utils/general.dart';
import 'package:flutter/cupertino.dart';

import '../../classes/tracker.dart';
import '../../classes/log.dart';
import 'alertDialogWithSetWidth.dart';
import '../select_log_value_sections.dart';

class AddLogWithChosenDateAlertDialog extends StatelessWidget
    with ChangeNotifier {
  final Tracker _trackerToWhichToAddLog;
  ChooseBooleanLogValueSection _chooseBooleanLogValueSection;
  ChooseIntegerLogValueSection _chooseIntegerLogValueSection;
  ChooseDecimalLogValueSection _chooseDecimalLogValueSection;

  /// used as a placeholder for the widget that is used to choose the log value
  Widget _chooseLogValueSection;

  /// Text that serves as a hint to the user that the below section is for
  /// choosing the log value of the log on the selected date
  Widget textAboveSelectLogValueSection;

  /// The date that was selected
  DateTime _selectedDate;

  AddLogWithChosenDateAlertDialog(this._trackerToWhichToAddLog) {
    // only initialize the object that is needed
    if (_trackerToWhichToAddLog.logType == bool) {
      _chooseBooleanLogValueSection = ChooseBooleanLogValueSection();
      _chooseLogValueSection = _chooseBooleanLogValueSection;
      textAboveSelectLogValueSection = Padding(
        child:
            Text('Did "${_trackerToWhichToAddLog.name}" happen on that day?'),
        padding: const EdgeInsets.only(top: 16.0),
      );
    } else if (_trackerToWhichToAddLog.logType == int) {
      _chooseIntegerLogValueSection = ChooseIntegerLogValueSection();
      _chooseLogValueSection = _chooseIntegerLogValueSection;
      textAboveSelectLogValueSection = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
            'Value of "${_trackerToWhichToAddLog.name}" on the chosen date:'),
      );
    }
    else if (_trackerToWhichToAddLog.logType == double) {
      _chooseDecimalLogValueSection = ChooseDecimalLogValueSection();
      _chooseLogValueSection = _chooseDecimalLogValueSection;
      textAboveSelectLogValueSection = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
            'Value of "${_trackerToWhichToAddLog.name}" on the chosen date:'),
      );
    }
    else {
      throw ('There is no widget for the selection of the given log type '
          '"${_trackerToWhichToAddLog.logType}"');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = convertTimeStampToDate(DateTime.now());
    CupertinoDatePicker datePicker = CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: currentDate,
      maximumDate: currentDate,
      onDateTimeChanged: (DateTime chosenDate) {
        _selectedDate = convertTimeStampToDate(chosenDate);
      },
    );

    /// Adds a log with the selected date and value to the tracker
    ///
    /// This function handles all log types.
    void popWithLogWithChosenDateAndValue() {
      Log createdLog;
      switch (_trackerToWhichToAddLog.logType) {
        case bool:
          createdLog = Log<bool>(
              Log.yesOrNoToBool(_chooseBooleanLogValueSection.chosenValue),
              timeStamp: _selectedDate);
          Navigator.of(context).pop(createdLog);
          break;
        case int:
          int enteredLogValue;
          bool enteredTextForLogValueIsParsable;
          try {
            enteredLogValue =
                int.parse(_chooseIntegerLogValueSection.chosenValueAsString);
            enteredTextForLogValueIsParsable = true;
          } on FormatException {
            // nothing is done when the entered value cannot be parsed (a
            // warning is shown to the user in another widget)
            enteredTextForLogValueIsParsable = false;
          }
          if (enteredTextForLogValueIsParsable) {
            Log<int> createdLog =
                Log<int>(enteredLogValue, timeStamp: _selectedDate);
            Navigator.of(context).pop(createdLog);
          }
          break;
        case double:
          double enteredLogValue;
          bool enteredTextForLogValueIsParsable;
          try {
            enteredLogValue =
                double.parse(_chooseDecimalLogValueSection.chosenValueAsString);
            enteredTextForLogValueIsParsable = true;
          } on FormatException {
            // nothing is done when the entered value cannot be parsed (a
            // warning is shown to the user in another widget)
            enteredTextForLogValueIsParsable = false;
          }
          if (enteredTextForLogValueIsParsable) {
            Log<double> createdLog =
                Log<double>(enteredLogValue, timeStamp: _selectedDate);
            Navigator.of(context).pop(createdLog);
          }
          break;
        default:
          throw('Unexpected log type "${_trackerToWhichToAddLog.logType}"');
      }
    }

    FlatButton addLogWithChosenDateButton = FlatButton(
      child: const Text(
        'Add',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => popWithLogWithChosenDateAndValue(),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    const Widget alertDialogTitle = Text('Choose date and value');
    Widget alertDialogContent = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 100,
            width: screenWidth > 300 ? 300.0 : screenWidth,
            child: datePicker,
          ),
          textAboveSelectLogValueSection,
          _chooseLogValueSection,
          Align(
            child: addLogWithChosenDateButton,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );

    // When screens are narrow, the Cupertino date picker might not get rendered
    // correctly because the width of the alert dialog is not enough because
    // the standard alert dialog requires a minimum margin around the dialog.
    // This is solved by using a custom dialog where the margin around the
    // dialog can be narrower, if the screen width is below a chosen threshold.
    if (screenWidth > 370) {
      return AlertDialog(
        title: alertDialogTitle,
        content: alertDialogContent,
      );
    } else {
      return AlertDialogWithSetWidth(
        minWidth: screenWidth > 300 ? 300.0 : screenWidth,
        title: alertDialogTitle,
        content: alertDialogContent,
      );
    }
  }
}
