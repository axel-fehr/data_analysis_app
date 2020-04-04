import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';

class TrackerLogsAnalysisRoute extends StatelessWidget {
  // tracker whose logs are shown and summarized on the screen
  final Tracker _tracker;

  TrackerLogsAnalysisRoute(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: Center(
        child: LogList(_tracker),
      ),
    );
  }
}

class LogList extends StatelessWidget {
  final Tracker _tracker;

  LogList(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text('Logs:'),
          Container(
            child: LogValuesWithEditButtonsListView(_tracker),
            height: 500,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class LogValuesWithEditButtonsListView extends StatelessWidget {
  // tracker whose logs are going to be shown as a list
  final Tracker _trackerCorrespondingToLogs;

  LogValuesWithEditButtonsListView(this._trackerCorrespondingToLogs);

  @override
  Widget build(BuildContext context) {
//    Tracker correspondingTracker = getTrackerWithTrackerName(context);
    List<Padding> logValueList = [];

    _trackerCorrespondingToLogs.logs.forEach((log) => logValueList.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LogWithEditButton(log, _trackerCorrespondingToLogs),
        )));

    return ListView(
      children: logValueList,
    );
  }
}

class LogWithEditButton extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  LogWithEditButton(this._log, this._trackerCorrespondingToLog);

  void showLogEditAlertDialog(BuildContext context) {
    // TODO: change the alert dialog depending on the type of the tracker (create one separate widget for each alert dialog (for each tracker type))
    bool oppositeValue = !_log.value;
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget changeLogButton = FlatButton(
      child: Text("Change to '$oppositeValue'"),
      onPressed: () {
        print('pressed change'); // TODO: remove this
        listOfTrackers.changeLogValue(_trackerCorrespondingToLog,
                                      _log.timeStamp,
                                      oppositeValue);
        Navigator.of(context).pop();
      },
    );

    Widget deleteLogButton = FlatButton(
      child: Icon(Icons.delete),
      onPressed: () {
        print('pressed delete'); // TODO: delete this
        listOfTrackers.deleteLog(_trackerCorrespondingToLog, _log.timeStamp);
        // TODO: make sure the time stamp recovered from the DB strings are the same as the original that is saved
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Edit Log'),
      actions: [
        changeLogButton,
        deleteLogButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(_log.value.toString())),
        InkWell(
          child: Icon(Icons.create),
          onTap: () => showLogEditAlertDialog(context), // print('edit'),
        ),
      ],
    );
  }
}
