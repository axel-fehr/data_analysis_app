import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import '../tracker_correlations.dart';
import 'binary_tracker_overall_stats.dart';
import '../../disclaimer_or_warning.dart';
import '../styling.dart';

class LogStatsOfBinaryTracker extends StatelessWidget {
  final String trackerName;

  const LogStatsOfBinaryTracker({
    @required this.trackerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          const SectionHeadline(
            textToDisplay: 'Overall Statistics',
          ),
          BinaryTrackerOverallStats(trackerName: trackerName),
          const SectionHeadline(
            textToDisplay: 'Correlations',
          ),
          BinaryTrackerCorrelations(nameOfTrackerBeingAnalyzed: trackerName),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: DisclaimerOrWarning(
              text: 'Correlation does not imply causation.',
            ),
          ),
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
