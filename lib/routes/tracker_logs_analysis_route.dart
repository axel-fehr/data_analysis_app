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
      body: LogList(_tracker),
    );
  }
}

class LogList extends StatelessWidget {
  final Tracker _tracker;

  LogList(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          child: Text(
            'Logs:',
            style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
        ),
        Expanded(
          child: LogValuesWithEditButtonsListView(_tracker),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class LogValuesWithEditButtonsListView extends StatefulWidget {
  // tracker whose logs are going to be shown as a list
  final Tracker _trackerCorrespondingToLogs;

  LogValuesWithEditButtonsListView(this._trackerCorrespondingToLogs);

  @override
  _LogValuesWithEditButtonsListViewState createState() =>
      _LogValuesWithEditButtonsListViewState();
}

class _LogValuesWithEditButtonsListViewState
    extends State<LogValuesWithEditButtonsListView> {
  /// Triggers a rebuild of the list of logs after the deletion of a log.
  ///
  /// This function is workaround needed because using the notifying all
  /// listeners after deleting a log of a tracker does not immediately trigger
  /// a rebuild of the list such that the log that was deleted does not
  /// disappear in the list. The reason for this is not entirely understood but
  /// could be because the context of the log that is being deleted is still
  /// there when the listeners are notified and the associated row in the list
  /// is therefore still rebuilt.
  /// Calling this function when a log is deleted in the LogWithEditButton
  /// widget ensures the list is immediately updated and the deleted log
  /// disappears as the user would expect.
  void updateLogListOnLogDeletion() {
    print('\n\nCallback executed!\n\n');
    // setState is empty because the change to the state was already done in
    // the function of the provider of the tracker list called in
    // showLogEditAlertDialog of the widget LogWithEditButton.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<LogWithEditButton> logValueList = [];

    widget._trackerCorrespondingToLogs.logs.forEach((log) => logValueList.add(
          LogWithEditButton(log, widget._trackerCorrespondingToLogs,
              updateLogListOnLogDeletionCallback: updateLogListOnLogDeletion),
        ));

    return ListView(
      children: logValueList,
    );
  }
}

class LogWithEditButton extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;
  final VoidCallback updateLogListOnLogDeletionCallback;

  LogWithEditButton(this._log, this._trackerCorrespondingToLog,
      {@required this.updateLogListOnLogDeletionCallback});

  void showLogEditAlertDialog(BuildContext context) {
    // TODO: change the alert dialog depending on the type of the tracker (create one separate widget for each alert dialog (for each tracker type))
    bool oppositeValue = !_log.value;
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget changeLogButton = FlatButton(
      child: Text("Change to '$oppositeValue'"),
      onPressed: () {
        print('pressed change'); // TODO: remove this
        listOfTrackers.changeLogValue(
            _trackerCorrespondingToLog, _log.timeStamp, oppositeValue);
        Navigator.of(context).pop();
      },
    );

    Widget deleteLogButton = FlatButton(
      child: Icon(Icons.delete),
      onPressed: () {
        print('pressed delete'); // TODO: delete this
        listOfTrackers.deleteLog(_trackerCorrespondingToLog, _log.timeStamp);
        Navigator.of(context).pop();
        // function call below is a needed workaround, see documentation of
        // 'updateLogListOnLogDeletion'
        updateLogListOnLogDeletionCallback();
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
    return ListTile(
      title: Text(_log.value.toString()),
      trailing: InkWell(
        child: Icon(Icons.create),
        onTap: () => showLogEditAlertDialog(context),
      ),
    );
  }
}
