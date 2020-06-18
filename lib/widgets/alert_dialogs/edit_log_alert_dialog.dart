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
      // TODO: add alert dialog for decimal logs
//      case double:
//        return ;
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

    return AlertDialog(
      title: Center(child: Text('Edit Log')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _chooseIntegerLogValueSection,
          Text(
            'If you tap "Change value", the log value will be set to the your chosen value',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
