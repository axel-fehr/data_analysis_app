import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';

class LogValuesWithEditButtonsListView extends StatefulWidget {
  // tracker whose logs are going to be shown as a list
  final Tracker _trackerCorrespondingToLogs;

  const LogValuesWithEditButtonsListView(this._trackerCorrespondingToLogs);

  @override
  _LogValuesWithEditButtonsListViewState createState() =>
      _LogValuesWithEditButtonsListViewState();
}

class _LogValuesWithEditButtonsListViewState
    extends State<LogValuesWithEditButtonsListView> {
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
    // setState is empty because the change to the state was already done in
    // the function of the provider of the tracker list called in
    // showLogEditAlertDialog of the widget LogWithEditButton.
    setState(() {});
  }
}

class LogWithEditButton extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;
  final VoidCallback updateLogListOnLogDeletionCallback;

  LogWithEditButton(this._log, this._trackerCorrespondingToLog,
      {@required this.updateLogListOnLogDeletionCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: LogValueWithDate(_log),
      trailing: InkWell(
        child: const Icon(Icons.create),
        onTap: () => showLogEditAlertDialog(context),
      ),
    );
  }

  void showLogEditAlertDialog(BuildContext context) {
    // TODO: change the alert dialog depending on the type of the tracker (create one separate widget for each alert dialog (for each tracker type))
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    bool oppositeValue = !_log.value;
    Widget changeLogButton = FlatButton(
      child: Text("Change to '${Log.boolToYesOrNo(oppositeValue)}'"),
      onPressed: () {
        print('pressed change'); // TODO: remove this
        listOfTrackers.changeLogValue(
            _trackerCorrespondingToLog, _log.timeStamp, oppositeValue);
        Navigator.of(context).pop();
      },
    );

    Widget deleteLogButton = FlatButton(
      child: const Icon(Icons.delete),
      onPressed: () {
        print('pressed delete'); // TODO: delete this
        listOfTrackers.deleteLog(_trackerCorrespondingToLog, _log.timeStamp);
        Navigator.of(context).pop();
        // function call below is a needed workaround, see documentation of
        // 'updateLogListOnLogDeletion'
        updateLogListOnLogDeletionCallback();
      },
    );

    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Edit Log'),
      actions: [
        changeLogButton,
        deleteLogButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class LogValueWithDate extends StatelessWidget {
  final Log _log;

  const LogValueWithDate(this._log);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(Log.boolToYesOrNo(_log.value)),
        Align(
          alignment: Alignment.center,
          child: Text(
            DateFormat.MMMd().format(_log.timeStamp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
