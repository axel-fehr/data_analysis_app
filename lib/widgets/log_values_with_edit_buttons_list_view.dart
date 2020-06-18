import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';
import './alert_dialogs/edit_log_alert_dialog.dart' show EditLogAlertDialog;

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
    // a copy of the tracker from the tracker list is needed here so that the
    // list gets updated when [notifyListeners()] is called in the tracker list
    // object after something (e.g. a log value) changed
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    Tracker trackerCopy = listOfTrackers.trackers.singleWhere(
      (tracker) => tracker.name == widget._trackerCorrespondingToLogs.name,
    );
    List<LogWithEditButton> logValueList = [];

    trackerCopy.logs.forEach(
      (log) => logValueList.add(
        LogWithEditButton(
          log,
          widget._trackerCorrespondingToLogs,
        ),
      ),
    );

    return ListView(
      children: logValueList,
    );
  }
}

class LogWithEditButton extends StatelessWidget {
  final Log _log;
  final Tracker _trackerCorrespondingToLog;

  LogWithEditButton(this._log, this._trackerCorrespondingToLog);

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditLogAlertDialog(
          _log,
          _trackerCorrespondingToLog,
        );
      },
    );
  }
}

class LogValueWithDate extends StatelessWidget {
  final Log _log;

  const LogValueWithDate(this._log);

  @override
  Widget build(BuildContext context) {
    String logValueAsString;
    Type logType = _log.value.runtimeType;

    if (logType == bool) {
      logValueAsString = Log.boolToYesOrNo(_log.value);
    } else if (logType == int || logType == double) {
      logValueAsString = _log.value.toString();
    } else {
      throw ('Unexpected runtime type of log value: $logType');
    }

    return Stack(
      children: <Widget>[
        Text(logValueAsString),
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
