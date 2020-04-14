import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
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
          LogStatsSectionHeadline(
            textToDisplay: 'Overall Statistics:',
            sectionHeadlineTextStyle: sectionHeadlineTextStyle,
          ),
          BinaryTrackerOverallStats(trackerName: trackerName),
//          BinaryTrackerStatsOverChosenPeriod(
//            trackerName: trackerName,
//            sectionHeadlineTextStyle: sectionHeadlineTextStyle,
//          ),
        ],
      ),
      height: 300,
    );
  }
}

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

class BinaryTrackerStatsOverChosenPeriod extends StatefulWidget {
  final String trackerName;
  final TextStyle sectionHeadlineTextStyle;

  BinaryTrackerStatsOverChosenPeriod({
    @required this.trackerName,
    @required this.sectionHeadlineTextStyle,
  });

  @override
  _BinaryTrackerStatsOverChosenPeriodState createState() =>
      _BinaryTrackerStatsOverChosenPeriodState();
}

class _BinaryTrackerStatsOverChosenPeriodState
    extends State<BinaryTrackerStatsOverChosenPeriod> {
  String chosenPeriod = 'Day'; // the period with which the statistics will be calculated
  // TODO: compute and display stats for given period
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          child: LogStatsSectionHeadline(
            textToDisplay: 'Statistics by ',
            sectionHeadlineTextStyle: widget.sectionHeadlineTextStyle,
          ),
          padding: EdgeInsets.only(top: 8.0),
        ),
        DropdownButton<String>(
          value: chosenPeriod,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
//          elevation: 16,
//          style: TextStyle(color: Colors.blue),
          underline: Container(
            height: 1,
            color: Colors.black,
          ),
          onChanged: (String newValue) {
            setState(() {
              chosenPeriod = newValue;
            });
          },
          items: <String>['Day', 'Week', 'Month']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
