import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../classes/log.dart';
import 'styling.dart';

class LogStatsOfBinaryTracker extends StatelessWidget {
  final String trackerName;
  final TextStyle sectionHeadlineTextStyle;

  LogStatsOfBinaryTracker({
    @required this.trackerName,
    @required this.sectionHeadlineTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Padding(
              child: Text(
                'Stats:',
                style: sectionHeadlineTextStyle,
              ),
              padding: EdgeInsets.only(left: 8.0),
            ),
            alignment: Alignment.centerLeft,
          ),
          BinaryTrackerOverallStats(
              trackerName: trackerName,
              sectionHeadlineTextStyle: sectionHeadlineTextStyle),
        ],
      ),
      height: 300,
    );
  }
}

/// Displays the statistics of all logs belonging to the tracker.
class BinaryTrackerOverallStats extends StatelessWidget {
  final String trackerName;
  final TextStyle sectionHeadlineTextStyle;

  BinaryTrackerOverallStats({
    @required this.trackerName,
    @required this.sectionHeadlineTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    Tracker tracker = listOfTrackers.trackers
        .singleWhere((tracker) => tracker.name == trackerName);
    int totalNumLogs = tracker.logs.length;
    int numTrueLogs = tracker.logs.where((log) => log.value == true).length;
    int numFalseLogs = totalNumLogs - numTrueLogs;
    int percentageTrue = ((numTrueLogs / totalNumLogs) * 100).toInt();
    int percentageFalse = 100 - percentageTrue;

    return Column(
      children: <Widget>[
        StatisticWithPadding('# logs: $totalNumLogs'),
        StatisticWithPadding('# true: $numTrueLogs'),
        StatisticWithPadding('# false: $numFalseLogs'),
        StatisticWithPadding('% true: $percentageTrue%'),
        StatisticWithPadding('% false: $percentageFalse%'),
      ],
    );
  }
}