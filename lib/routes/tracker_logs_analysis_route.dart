import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracking_app/utils/general.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';
import '../widgets/log_values_with_edit_buttons_list_view.dart';
import '../widgets/log_statistics_widgets/tracker_log_stats.dart';
import '../widgets/log_statistics_widgets/styling.dart';
import '../widgets/alert_dialogs/add_log_with_chosen_date_alert_dialog.dart';
import '../utils/rename_tracker_utils.dart' as rename_tracker_utils;

class TrackerLogsAnalysisRoute extends StatelessWidget {
  // tracker whose logs are shown and summarized on the screen
  final Tracker _tracker;

  TrackerLogsAnalysisRoute(this._tracker);

  @override
  Widget build(BuildContext context) {
    void handlePopUpMenuTap(String value) {
      switch (value) {
        case 'Rename':
          print('rename');
          rename_tracker_utils.letUserRenameTracker(context, _tracker.name);
          break;
        case 'Delete':
          letUserConfirmTrackerDeletion(context, trackerToDelete: _tracker);
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_tracker.name),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handlePopUpMenuTap,
            itemBuilder: (BuildContext context) {
              return {'Rename', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: LogListAndStats(_tracker),
    );
  }

  void letUserConfirmTrackerDeletion(BuildContext context,
      {@required Tracker trackerToDelete}) {
    Widget noButton = FlatButton(
      child: const Text('No'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: const Text('Yes'),
      onPressed: () {
        Provider.of<TrackerList>(context).deleteTracker(_tracker);
        // back to the home screen
        Navigator.popUntil(context, ModalRoute.withName('/'));
      },
    );

    CupertinoAlertDialog addLogAlertDialog = CupertinoAlertDialog(
      title: const Text('Are you sure?'),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addLogAlertDialog;
      },
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
        LogStatsSection(
          trackerToComputeStatsWith: _tracker,
        ),
        const Divider(
          color: Colors.black,
        ),
        Expanded(
          child: LogListSection(tracker: _tracker),
        ),
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
    InkWell addLogWithSpecificDateButton = InkWell(
      child: Container(
        child: const Text(
          'Add log with specific date',
          style: TextStyle(color: Colors.blueAccent),
        ),
        margin: const EdgeInsets.all(8.0),
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
              TrackerList listOfTrackers = Provider.of<TrackerList>(context);
              listOfTrackers.addLog(_tracker, onValue);
            }
          }
        });
      },
    );

    return Column(
      children: <Widget>[
        addLogWithSpecificDateButton,
        SectionHeadline(
          textToDisplay: 'Logs of "${_tracker.name}"',
        ),
        Expanded(
          child: LogValuesWithEditButtonsListView(_tracker),
        ),
      ],
    );
  }

  Future<Log> showAddLogWithSpecificDateAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddLogWithChosenDateAlertDialog(_tracker);
        });
  }

  void notifyUserThatLogWithSameDateAlreadyExists(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'A log with the same date already exists.',
        style: TextStyle(fontSize: 18.0),
      ),
      duration: Duration(seconds: 3),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}

class LogStatsSection extends StatelessWidget {
  final Tracker trackerToComputeStatsWith;

  const LogStatsSection({
    @required this.trackerToComputeStatsWith,
  });

  @override
  Widget build(BuildContext context) {
    return LogStatsOfTracker(
      trackerToComputeStatsWith: trackerToComputeStatsWith,
    );
  }
}
