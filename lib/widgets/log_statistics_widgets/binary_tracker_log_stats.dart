import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'binary_tracker_correlations.dart';
import 'binary_tracker_overall_stats.dart';
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
          LogStatsSectionHeadline(
            textToDisplay: 'Correlations:',
            sectionHeadlineTextStyle: sectionHeadlineTextStyle,
          ),
          BinaryTrackerCorrelations(trackerName: trackerName),
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
