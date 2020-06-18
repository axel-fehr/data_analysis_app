import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:tracking_app/providers/tracker_list.dart';
import 'package:tracking_app/classes/tracker.dart';
import 'package:tracking_app/classes/log.dart';

/// An alert dialog changes depending on the type of log that is being edited
/// and can therefore be used for the editing of any type of log.
class EditLogAlertDialog extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  EditLogAlertDialog(this._log, this._trackerCorrespondingToLog);

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

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Edit Log'),
      actions: [
        changeLogButton,
        deleteLogButton,
      ],
    );

    return alert;
  }
}
