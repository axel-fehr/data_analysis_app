import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'binary_tracker_correlations.dart';
import 'binary_tracker_overall_stats.dart';
import '../styling.dart';

class LogStatsOfBinaryTracker extends StatelessWidget {
  final String trackerName;

  LogStatsOfBinaryTracker({
    @required this.trackerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SectionHeadline(
            textToDisplay: 'Overall Statistics',
          ),
          BinaryTrackerOverallStats(trackerName: trackerName),
          SectionHeadline(
            textToDisplay: 'Correlations',
          ),
          BinaryTrackerCorrelations(nameOfTrackerBeingAnalyzed: trackerName),
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
