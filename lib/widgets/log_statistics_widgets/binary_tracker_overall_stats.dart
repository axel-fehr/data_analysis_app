import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import 'styling.dart';

/// Displays the statistics of all logs belonging to the tracker.
class BinaryTrackerOverallStats extends StatelessWidget {
  final String trackerName;

  BinaryTrackerOverallStats({
    @required this.trackerName,
  });

  @override
  Widget build(BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    Tracker tracker = listOfTrackers.trackers
        .singleWhere((tracker) => tracker.name == trackerName);
    int totalNumLogs = tracker.logs.length;
    int numTrueLogs = tracker.logs.where((log) => log.value == true).length;
    int numFalseLogs = totalNumLogs - numTrueLogs;

    int percentageTrue;
    int percentageFalse;
    if (totalNumLogs != 0) {
      percentageTrue = ((numTrueLogs / totalNumLogs) * 100).toInt();
      percentageFalse = 100 - percentageTrue;
    }

    List<Widget> statsToDisplay = [
      StatisticWithPadding('# logs: $totalNumLogs'),
      StatisticWithPadding('# true: $numTrueLogs'),
      StatisticWithPadding('# false: $numFalseLogs'),
    ];

    if (totalNumLogs != 0) {
      statsToDisplay.add(StatisticWithPadding('% true: $percentageTrue%'));
      statsToDisplay.add(StatisticWithPadding('% false: $percentageFalse%'));
    }

    return Column(
      children: statsToDisplay,
    );
  }
}