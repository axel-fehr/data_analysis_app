import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'tracker_correlations.dart';
import 'tracker_overall_stats.dart';
import '../disclaimer_or_warning.dart';
import 'styling.dart';

/// A widget that displays basic statistics of a tracker and a list of
/// correlations with other trackers. It can be used for any type of tracker.
class LogStatsOfTracker extends StatelessWidget {
  final String trackerName;

  const LogStatsOfTracker({
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
          TrackerOverallStats(trackerName: trackerName),
          const SectionHeadline(
            textToDisplay: 'Correlations',
          ),
          TrackerCorrelations(nameOfTrackerBeingAnalyzed: trackerName),
          const Padding(
            padding: EdgeInsets.only(top: 4.0),
            child: DisclaimerOrWarning(
              text: 'Correlation does not imply causation.',
            ),
          ),
        ],
      ),
      height: 300,
    );
  }
}
