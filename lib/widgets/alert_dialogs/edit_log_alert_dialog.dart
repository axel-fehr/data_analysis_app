import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:tracking_app/providers/tracker_list.dart';
import 'package:tracking_app/classes/tracker.dart';
import 'package:tracking_app/classes/log.dart';
import '../select_log_value_sections.dart';

/// An alert dialog changes depending on the type of log that is being edited
/// and can therefore be used for the editing of any type of log.
class EditLogAlertDialog extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  const EditLogAlertDialog(this._log, this._trackerCorrespondingToLog);

  @override
  Widget build(BuildContext context) {
    switch (_trackerCorrespondingToLog.logType) {
      case bool:
        return EditBooleanLogAlertDialog(_log, _trackerCorrespondingToLog);
      case int:
        return EditIntegerLogAlertDialog(_log, _trackerCorrespondingToLog);
     case double:
       return EditDecimalLogAlertDialog(_log, _trackerCorrespondingToLog);
      default:
        throw ('Unexpected log type encountered: ${_trackerCorrespondingToLog.logType}');
    }
  }
}

class EditBooleanLogAlertDialog extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  const EditBooleanLogAlertDialog(this._log, this._trackerCorrespondingToLog);

  @override
  Widget build(BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    bool oppositeValue = !_log.value;
    Widget changeLogButton = FlatButton(
      child: Text("Change to '${Log.boolToYesOrNo(oppositeValue)}'"),
      onPressed: () {
        listOfTrackers.changeLogValue(
            _trackerCorrespondingToLog, _log.timeStamp, oppositeValue);
        Navigator.of(context).pop();
      },
    );

    Widget deleteLogButton = FlatButton(
      child: const Icon(Icons.delete),
      onPressed: () {
        listOfTrackers.deleteLog(_trackerCorrespondingToLog, _log.timeStamp);
        Navigator.of(context).pop();
      },
    );

    CupertinoAlertDialog alertDialog = CupertinoAlertDialog(
      title: const Text('Edit Log'),
      actions: [
        changeLogButton,
        deleteLogButton,
      ],
    );

    return alertDialog;
  }
}

class EditIntegerLogAlertDialog extends StatefulWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  const EditIntegerLogAlertDialog(this._log, this._trackerCorrespondingToLog);

  @override
  _EditIntegerLogAlertDialogState createState() =>
      _EditIntegerLogAlertDialogState();
}

class _EditIntegerLogAlertDialogState extends State<EditIntegerLogAlertDialog> {
  @override
  Widget build(BuildContext context) {
    ChooseIntegerLogValueSection _chooseIntegerLogValueSection =
        ChooseIntegerLogValueSection();

    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget changeLogButton = FlatButton(
      child: const Text('Change value'),
      onPressed: () {
        bool enteredValueIsParableAsInt;
        int newLogValue;
        try {
          newLogValue =
              int.parse(_chooseIntegerLogValueSection.chosenValueAsString);
          enteredValueIsParableAsInt = true;
        } on Error {
          enteredValueIsParableAsInt = false;
        }
        if (enteredValueIsParableAsInt) {
          listOfTrackers.changeLogValue(
            widget._trackerCorrespondingToLog,
            widget._log.timeStamp,
            newLogValue,
          );
          Navigator.of(context).pop();
        }
      },
    );

    Widget deleteLogButton = FlatButton(
      child: const Icon(Icons.delete),
      onPressed: () {
        listOfTrackers.deleteLog(
          widget._trackerCorrespondingToLog,
          widget._log.timeStamp,
        );
        Navigator.of(context).pop();
      },
    );

    return AlertDialog(
      title: const Center(child: Text('Edit Log')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _chooseIntegerLogValueSection,
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'If you tap "Change value", the log value will be set to the '
                    'your chosen value',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[changeLogButton, deleteLogButton],
    );
  }
}

class EditDecimalLogAlertDialog extends StatefulWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  const EditDecimalLogAlertDialog(this._log, this._trackerCorrespondingToLog);

  @override
  _EditDecimalLogAlertDialogState createState() =>
      _EditDecimalLogAlertDialogState();
}

class _EditDecimalLogAlertDialogState extends State<EditDecimalLogAlertDialog> {
  @override
  Widget build(BuildContext context) {
    ChooseDecimalLogValueSection _chooseDecimalLogValueSection =
        ChooseDecimalLogValueSection();

    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget changeLogButton = FlatButton(
      child: const Text('Change value'),
      onPressed: () {
        bool enteredValueIsParableAsInt;
        double newLogValue;
        try {
          newLogValue =
              double.parse(_chooseDecimalLogValueSection.chosenValueAsString);
          enteredValueIsParableAsInt = true;
        } on Error {
          enteredValueIsParableAsInt = false;
        }
        if (enteredValueIsParableAsInt) {
          listOfTrackers.changeLogValue(
            widget._trackerCorrespondingToLog,
            widget._log.timeStamp,
            newLogValue,
          );
          Navigator.of(context).pop();
        }
      },
    );

    Widget deleteLogButton = FlatButton(
      child: const Icon(Icons.delete),
      onPressed: () {
        listOfTrackers.deleteLog(
          widget._trackerCorrespondingToLog,
          widget._log.timeStamp,
        );
        Navigator.of(context).pop();
      },
    );

    return AlertDialog(
      title: const Center(child: Text('Edit Log')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _chooseDecimalLogValueSection,
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'If you tap "Change value", the log value will be set to the '
                    'your chosen value',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[changeLogButton, deleteLogButton],
    );
  }
}

