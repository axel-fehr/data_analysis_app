import 'package:flutter/material.dart';
import 'package:tracking_app/utils/general.dart';

import 'select_date_calendar_view.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';

class AddLogWithChosenDateAlertDialog extends StatefulWidget {
  final Tracker _tracker;

  const AddLogWithChosenDateAlertDialog(this._tracker);

  @override
  _AddLogWithChosenDateAlertDialogState createState() =>
      _AddLogWithChosenDateAlertDialogState();
}

class _AddLogWithChosenDateAlertDialogState
    extends State<AddLogWithChosenDateAlertDialog> {
  SelectLogValueSection selectLogValueSection;
  SelectDateCalendarView calendarView = SelectDateCalendarView();
  Color _addLogButtonFontColor = Colors.black45;
  bool _userSelectedFutureDate = false;

  @override
  Widget build(BuildContext context) {
    // only builds the widget the first time the build method is called
    selectLogValueSection ??= SelectLogValueSection(widget._tracker);

    calendarView.onDateSelected ??= () {
      // updates the font color of the 'Add' button to indicate the log can be
      // added, now that the date has been selected
      setState(() {
        DateTime currentDate = convertTimeStampToDate(DateTime.now());
        _userSelectedFutureDate =
            calendarView.selectedDate.isAfter(currentDate) ? true : false;

        // changes the color of the button depending on whether the chosen
        // date is valid or not and whether the log can be added as a signal to
        // the user
        _addLogButtonFontColor =
            _userSelectedFutureDate ? Colors.black45 : Colors.blue;
      });
    };

    // warning that will be shown when user selects future date because
    // logs with future dates are not accepted
    Widget doNotChooseFutureDateWarning = Visibility(
        visible: _userSelectedFutureDate,
        child: Flexible(
          child: Column(
            children: <Widget>[
              const Text(
                'Please do not choose a future date.',
                style: TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ));

    FlatButton addLogWithChosenDateButton = FlatButton(
      child: Text(
        'Add',
        style: TextStyle(color: _addLogButtonFontColor),
      ),
      onPressed: () {
        if (calendarView.userSelectedDate && !_userSelectedFutureDate) {
          Log createdLog = Log(
              Log.yesOrNoToBool(selectLogValueSection.selectedValue),
              timeStamp: calendarView.selectedDate);
          print('chosen date: ${createdLog.toString()}');
          Navigator.of(context).pop(createdLog);
        }
      },
    );

    return AlertDialog(
        title: const Text('Choose date and value'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 330,
                child: calendarView,
              ),
              selectLogValueSection,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  doNotChooseFutureDateWarning,
                  addLogWithChosenDateButton,
                ],
              )
            ],
          ),
        ));
  }
}

// TODO: put this in a separate file
class SelectLogValueSection extends StatefulWidget {
  final Tracker _tracker;

  SelectLogValueSection(this._tracker);

  String _selectedValue = Log.boolToYesOrNo(true);

  String get selectedValue => _selectedValue;

  @override
  _SelectLogValueSectionState createState() => _SelectLogValueSectionState();
}

class _SelectLogValueSectionState extends State<SelectLogValueSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text('Did "${widget._tracker.name}" happen on that day?'),
          padding: const EdgeInsets.only(top: 8.0),
        ),
        Row(
          children: <Widget>[
            const Icon(Icons.arrow_forward),
            Container(
              child: DropdownButton<String>(
                value: widget._selectedValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    widget._selectedValue = newValue;
                  });
                },
                items: <String>[
                  Log.boolToYesOrNo(true),
                  Log.boolToYesOrNo(false)
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
