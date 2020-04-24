import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracking_app/utils/general.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';
import '../widgets/log_statistics_widgets/for_binary_trackers/binary_tracker_log_stats.dart';
import '../widgets/log_statistics_widgets/styling.dart';
import '../widgets/select_date_calendar_view.dart';
import '../widgets/add_log_with_chosen_date_alert_dialog.dart';

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
      body: LogListAndStats(_tracker),
    );
  }
}

class LogListAndStats extends StatelessWidget {
  final Tracker _tracker;

  LogListAndStats(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: LogListSection(tracker: _tracker),
        ),
        Divider(
          color: Colors.black,
        ),
        LogStatsSection(
          trackerName: _tracker.name,
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

class LogListSection extends StatelessWidget {
  const LogListSection({
    Key key,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  final Tracker _tracker;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeadline(
          textToDisplay: 'Logs',
        ),
        Expanded(
          child: LogValuesWithEditButtonsListView(_tracker),
        ),
        InkWell(
          child: Text(
            'Add log with specific date',
            style: TextStyle(color: Colors.blueAccent),
          ),
          onTap: () {
            showAddLogWithSpecificDateAlertDialog(context).then((Log onValue) {
              if (onValue != null) {
                DateTime dateOfCreatedLog =
                    convertTimeStampToDate(onValue.timeStamp);
                List<DateTime> datesOfLogs = List.generate(_tracker.logs.length,
                    (i) => convertTimeStampToDate(_tracker.logs[i].timeStamp));

                // only adds the created log if no other log with the
                // same date exists.
                if (datesOfLogs.contains(dateOfCreatedLog)) {
                  notifyUserThatLogWithSameDateAlreadyExists(context);
                } else {
                  TrackerList listOfTrackers =
                      Provider.of<TrackerList>(context);
                  listOfTrackers.addLog(_tracker, onValue);
                }
                // TODO: sort log list according to dates
              }
            });
          },
        ),
      ],
    );
  }

  Future<Log> showAddLogWithSpecificDateAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddLogWithChosenDateAlertDialog(); //SelectDateCalendarView();
        });
  }

  void notifyUserThatLogWithSameDateAlreadyExists(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'A log with the same date already exists.',
        style: TextStyle(fontSize: 18.0),
      ),
      duration: Duration(seconds: 3),
    );
    Scaffold.of(context).showSnackBar(snackBar);
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
      title: Text(_log.value.toString()),
      trailing: InkWell(
        child: Icon(Icons.create),
        onTap: () => showLogEditAlertDialog(context),
      ),
    );
  }

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
}

class LogStatsSection extends StatelessWidget {
  final String trackerName;

  LogStatsSection({
    @required this.trackerName,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: return a different widget here depending on the tracker type
    return LogStatsOfBinaryTracker(
      trackerName: trackerName,
    );
  }
}
