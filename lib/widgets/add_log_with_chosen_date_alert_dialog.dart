import 'package:flutter/material.dart';
import 'package:tracking_app/utils/general.dart';
import 'package:flutter/cupertino.dart';

import '../classes/tracker.dart';
import '../classes/log.dart';
import 'alertDialogWithSetWidth.dart';

class AddLogWithChosenDateAlertDialog extends StatelessWidget {
  final Tracker _tracker;

  const AddLogWithChosenDateAlertDialog(this._tracker);

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate;

    SelectLogValueSection selectLogValueSection =
        SelectLogValueSection(_tracker);

    DateTime currentDate = convertTimeStampToDate(DateTime.now());
    CupertinoDatePicker datePicker = CupertinoDatePicker(
      mode: CupertinoDatePickerMode.date,
      initialDateTime: currentDate,
      maximumDate: currentDate,
      onDateTimeChanged: (DateTime chosenDate) {
        _selectedDate = convertTimeStampToDate(chosenDate);
      },
    );

    FlatButton addLogWithChosenDateButton = FlatButton(
      child: const Text(
        'Add',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () {
        Log createdLog = Log(
            Log.yesOrNoToBool(selectLogValueSection.selectedValue),
            timeStamp: _selectedDate);
        print('created log: ${createdLog.toString()}');
        Navigator.of(context).pop(createdLog);
      },
    );

    Widget alertDialogTitle = const Text('Choose date and value');
    Widget alertDialogContent = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 100,
            child: datePicker,
          ),
          selectLogValueSection,
          Align(
            child: addLogWithChosenDateButton,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );

    double screenWidth = MediaQuery.of(context).size.width;

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
