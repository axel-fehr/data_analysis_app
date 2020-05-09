import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import 'binary_tracker_correlations.dart';
import 'binary_tracker_overall_stats.dart';
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
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: DisclaimerOrWarning(
              text: 'The information provided on this app is not health advice.',
            ),
          ),
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

class DisclaimerOrWarning extends StatelessWidget {
  final String text;

  const DisclaimerOrWarning({@required this.text});

  static const Color _color = Colors.black45;
  static const double _size = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.warning,
            size: _size,
            color: _color,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: _size, color: _color),
          ),
        ],
      ),
    );
  }
}
