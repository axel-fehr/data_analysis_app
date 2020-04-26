import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../providers/tracker_list.dart';
import '../../../classes/tracker.dart';
import '../styling.dart';

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

    List<Widget> statsToDisplay = [
      StatisticWithPadding('# logs: $totalNumLogs'),
    ];

    String yesLogsStatistic = '# Yes: $numTrueLogs';
    String noLogsStatistic = '# No: $numFalseLogs';

    if (totalNumLogs != 0) {
      int percentageTrue = ((numTrueLogs / totalNumLogs) * 100).toInt();
      int percentageFalse = 100 - percentageTrue;
      yesLogsStatistic += ' ($percentageTrue%)';
      noLogsStatistic += ' ($percentageFalse%)';
    }

    statsToDisplay.add(StatisticWithPadding(yesLogsStatistic));
    statsToDisplay.add(StatisticWithPadding(noLogsStatistic));

    return Column(
      children: statsToDisplay,
    );
  }
}