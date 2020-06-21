import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/utils/math_utils.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../classes/log.dart';
import 'styling.dart';

/// Displays the statistics of all logs belonging to the tracker.
class TrackerOverallStats extends StatelessWidget {
  final Tracker trackerToComputeStatsWith;

  TrackerOverallStats({
    @required this.trackerToComputeStatsWith,
  });

  @override
  Widget build(BuildContext context) {
    // a copy of the tracker the tracker list is needed here so that the
    // statistics update when [notifyListeners()] is called in the tracker list
    // object after something (e.g. a log value) changed
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    Tracker trackerCopy = listOfTrackers.trackers.singleWhere(
        (tracker) => tracker.name == trackerToComputeStatsWith.name);
    int totalNumLogs = trackerCopy.logs.length;

    List<Widget> statsToDisplay = [
      StatisticWithPadding('# logs: $totalNumLogs'),
    ];

    switch (trackerToComputeStatsWith.logType) {
      case bool:
        statsToDisplay = _addStatsForBooleanTrackers(statsToDisplay);
        break;
      case int:
        statsToDisplay = _addStatsForIntegerTrackers(statsToDisplay);
        break;
      case double:
        statsToDisplay = _addStatsForDecimalTrackers(statsToDisplay);
        break;
      default:
        throw ('Unexpected log type "${trackerToComputeStatsWith.logType}" encountered');
    }

    return Column(
      children: statsToDisplay,
    );
  }

  List<Widget> _addStatsForBooleanTrackers(List<Widget> statsToDisplay) {
    int numTrueLogs =
        trackerToComputeStatsWith.logs.where((log) => log.value == true).length;
    int totalNumLogs = trackerToComputeStatsWith.logs.length;
    int numFalseLogs = totalNumLogs - numTrueLogs;

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

    return statsToDisplay;
  }

  List<Widget> _addStatsForIntegerTrackers(List<Widget> statsToDisplay) {
    if (trackerToComputeStatsWith.logs.isNotEmpty) {
      List<int> logValuesAsInt = <int>[];
      List<double> logValuesAsDoubles = <double>[];
      trackerToComputeStatsWith.logs.forEach((Log log) {
        logValuesAsInt.add(log.value);
        logValuesAsDoubles.add(log.value.toDouble());
      });

      double meanValue = mean(logValuesAsDoubles);
      double medianValue = median(logValuesAsDoubles);
      List<int> modeValues = mode(logValuesAsInt);

      String meanStatistic = 'Mean: ${meanValue.toStringAsFixed(2)}';
      statsToDisplay.add(StatisticWithPadding(meanStatistic));

      if (logValuesAsInt.length > 1) {
        String medianStatistic = 'Median: ${medianValue.toStringAsFixed(2)}';
        statsToDisplay.add(StatisticWithPadding(medianStatistic));
      }

      if (modeValues.isNotEmpty) {
        String medianStatistic = 'Mode: ';

        // reduce list of values shown to be the mode to 5 if there are more
        // than 5 values for the mode
        if (modeValues.length > 5) {
          modeValues = modeValues.sublist(0, 5);
        }

        modeValues.forEach((value) {
          medianStatistic += '$value, ';
        });
        // remove the last two characters from the string (the space and the
        // comma)
        medianStatistic =
            medianStatistic.substring(0, medianStatistic.length - 2);

        statsToDisplay.add(StatisticWithPadding(medianStatistic));
      }
    }

    return statsToDisplay;
  }

  List<Widget> _addStatsForDecimalTrackers(List<Widget> statsToDisplay) {
    if (trackerToComputeStatsWith.logs.isNotEmpty) {
      List<double> logValues = List.generate(
          trackerToComputeStatsWith.logs.length,
          (index) => trackerToComputeStatsWith.logs[index].value);

      double meanValue = mean(logValues);
      double medianValue = median(logValues);

      String meanStatistic = 'Mean: ${meanValue.toStringAsFixed(2)}';
      statsToDisplay.add(StatisticWithPadding(meanStatistic));

      if (logValues.length > 1) {
        String medianStatistic = 'Median: ${medianValue.toStringAsFixed(2)}';
        statsToDisplay.add(StatisticWithPadding(medianStatistic));
      }
    }
    return statsToDisplay;
  }
}
