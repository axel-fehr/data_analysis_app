import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracking_app/utils/general.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';
import '../widgets/log_values_with_edit_buttons_list_view.dart';
import '../widgets/log_statistics_widgets/for_binary_trackers/binary_tracker_log_stats.dart';
import '../widgets/log_statistics_widgets/styling.dart';
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
    InkWell addLogWithSpecificDateButton = InkWell(
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
              TrackerList listOfTrackers = Provider.of<TrackerList>(context);
              listOfTrackers.addLog(_tracker, onValue);
            }
          }
        });
      },
    );

    return Column(
      children: <Widget>[
        SectionHeadline(
          textToDisplay: 'Logs',
        ),
        Expanded(
          child: LogValuesWithEditButtonsListView(_tracker),
        ),
        addLogWithSpecificDateButton,
      ],
    );
  }

  Future<Log> showAddLogWithSpecificDateAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddLogWithChosenDateAlertDialog();
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
