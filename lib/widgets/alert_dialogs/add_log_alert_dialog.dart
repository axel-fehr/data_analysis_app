import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../classes/log.dart';

class AddLogAlertDialog extends StatelessWidget {
  final Tracker _trackerToWhichToAddLog;

  // This has to be a function that triggers the rebuild of the tracker list
  // and its buttons. This is needed so that a button can be deactivated until
  // the next day when a log was added (logs are added only once per day per
  // tracker).
  final VoidCallback _triggerTrackerListRebuild;

  AddLogAlertDialog(
      this._trackerToWhichToAddLog, this._triggerTrackerListRebuild);

  @override
  Widget build(BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget falseButton = FlatButton(
      child: const Text('No'),
      onPressed: () {
        listOfTrackers.addLog(_trackerToWhichToAddLog, Log<bool>(false));
        _triggerTrackerListRebuild();
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
      },
    );

    Widget trueButton = FlatButton(
      child: const Text('Yes'),
      onPressed: () {
        listOfTrackers.addLog(_trackerToWhichToAddLog, Log<bool>(true));
        _triggerTrackerListRebuild();
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
      },
    );

    CupertinoAlertDialog addLogAlertDialog = CupertinoAlertDialog(
      title: const Text('Log'),
      content: Text('Did "${_trackerToWhichToAddLog.name}" happen today?'),
      actions: [
        trueButton,
        falseButton,
      ],
    );

    return addLogAlertDialog;
  }
}
