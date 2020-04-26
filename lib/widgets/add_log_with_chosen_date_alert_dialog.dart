import 'package:flutter/material.dart';

import 'select_date_calendar_view.dart';
import '../classes/log.dart';

class AddLogWithChosenDateAlertDialog extends StatefulWidget {
  @override
  _AddLogWithChosenDateAlertDialogState createState() =>
      _AddLogWithChosenDateAlertDialogState();
}

class _AddLogWithChosenDateAlertDialogState
    extends State<AddLogWithChosenDateAlertDialog> {
  SelectLogValueSection selectLogValueSection = SelectLogValueSection();
  Color _addLogButtonFontColor = Colors.black45;
  bool _userSelectedDate = false;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // the reinstantiation is required in the build method so that the setState
    // method can be used. This means though that the selected date has to be
    // preserved in the parent class. This is all done to change the color of
    // the add button text depending on whether a date was chosen or not.
    SelectDateCalendarView calendarView = SelectDateCalendarView(
      userSelectedDate: _userSelectedDate,
      selectedDate: _selectedDate,
    );

    calendarView.onDateSelected = () {
      // updates the font color of the 'Add' button to indicate the log can be
      // added, now that the date has been selected
      setState(() {
        print('\nupdating state');
        _userSelectedDate = true;
        _selectedDate = calendarView.selectedDate;
        _addLogButtonFontColor = Colors.blue;
      });
    };

    double calendarViewHeight = 300;
      return AlertDialog(
          title: Text('Choose value and date'),
          content: Container(
            height: calendarViewHeight + 123,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                selectLogValueSection,
                Container(
                  height: calendarViewHeight,
                  child: calendarView,
                ),
                Align(
                  child: FlatButton(
                    child: Text(
                      'Add',
                      style: TextStyle(color: _addLogButtonFontColor),
                    ),
                    onPressed: () {
                      print('add button pressed, date chosen: ${calendarView.userSelectedDate}');
                      if (calendarView.userSelectedDate) {
                        Log createdLog = Log(Log.yesOrNoToBool(selectLogValueSection.selectedValue),
                            timeStamp: calendarView.selectedDate);
                        print('chosen date: ${createdLog.toString()}');
                        Navigator.of(context).pop(createdLog);
                      }
                    },
                  ),
                  alignment: Alignment.centerRight,
                )
              ],
            ),
          ));
    }
}

// TODO: put this in a separate file
class SelectLogValueSection extends StatefulWidget {
  String _selectedValue = Log.boolToYesOrNo(true);

  String get selectedValue => _selectedValue;

  @override
  _SelectLogValueSectionState createState() => _SelectLogValueSectionState();
}

class _SelectLogValueSectionState extends State<SelectLogValueSection> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          child: Text('Log value: '),
          padding: EdgeInsets.only(top: 8.0),
        ),
        Container(
          child: DropdownButton<String>(
            value: widget._selectedValue,
            icon: Icon(Icons.arrow_downward),
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
            items:
                <String>[Log.boolToYesOrNo(true), Log.boolToYesOrNo(false)].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          margin: EdgeInsets.only(top: 8.0),
        ),
      ],
    );
  }
}
