import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

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

class BinaryTrackerCorrelations extends StatelessWidget {
  final String
      trackerName; // TODO: give this a more descriptive and less ambiguous name

  BinaryTrackerCorrelations({
    @required this.trackerName,
  });

  /// Returns a map containing the correlation coefficients between the logs
  /// of the tracker with the given tracker name and the logs of the other
  /// trackers, descendingly ordered by magnitude.
  ///
  /// Output:
  /// A map with two entries:
  /// 1. a list of tracker names as Strings,
  /// 2. a list of correlation coefficients as doubles that were computed with
  /// the trackers given in the list of tracker names (same order). This list
  /// is ordered by magnitude in descending order.
  Map getCorrelationsWithOtherTrackersOrderedByMagnitude(BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    listOfTrackers.trackers
        .forEach((tracker) => checkIfMultipleLogsOnSameDay(tracker));
    List<Tracker> trackerListCopy = List<Tracker>.from(listOfTrackers.trackers);
    Tracker trackerCorrespondingToLogs =
        trackerListCopy.singleWhere((tracker) => tracker.name == trackerName);
    trackerListCopy.remove(
        trackerCorrespondingToLogs); // avoids computing the correlation with the tracker itself

    List<double> correlationsWithOtherTrackers = [];
    List<String> namesOfOtherTrackers = [];
    trackerListCopy.forEach((otherTracker) {
      if (trackerLogsOverlap(trackerCorrespondingToLogs, otherTracker)) {
        double correlation = computeCorrelationBetweenTwoTrackers(
            trackerCorrespondingToLogs, otherTracker);
        correlationsWithOtherTrackers.add(correlation);
        namesOfOtherTrackers.add(otherTracker.name);
      }
    });

    Map sortedCorrelationsAndTrackerNames =
        sortCorrelationsByMagnitudeAndSortTrackerNamesAccordingly(
            correlationsWithOtherTrackers, namesOfOtherTrackers);

    return {
      'correlations': sortedCorrelationsAndTrackerNames['correlations'],
      'trackerNames': sortedCorrelationsAndTrackerNames['trackerNames'],
    };
  }

  /// Returns a Boolean value indicating whether there is at least one log in
  /// one tracker that was added on the same day as a log in the other tracker.
  bool trackerLogsOverlap(Tracker tracker1, Tracker tracker2) {
    if (tracker1.logs.isEmpty || tracker2.logs.isEmpty) {
      return false;
    }
    tracker1.logs.forEach((tracker1Log) {
      tracker2.logs.forEach((tracker2Log) {
        if (convertTimeStampToDate(tracker1Log.timeStamp) ==
            convertTimeStampToDate(tracker2Log.timeStamp)) {
          return true;
        }
      });
    });
    return false;
  }

  /// Computes the correlation coefficient between the logs of the two given
  /// trackers.
  ///
  /// The coefficient is only computed with logs where a log with the same time
  /// stamp date can also be found in the other tracker. The remaining logs are
  /// ignored.
  double computeCorrelationBetweenTwoTrackers(
      Tracker tracker1, Tracker tracker2) {
    List<List<int>> sameDateLogsIndices =
        getIndicesOfLogsAddedOnTheSameDay(tracker1.logs, tracker2.logs);
    List<int> tracker1MatchingLogIndices = sameDateLogsIndices.elementAt(0);
    List<int> tracker2MatchingLogIndices = sameDateLogsIndices.elementAt(1);

    List<Log> tracker1MatchingLogs = List.generate(
        tracker1MatchingLogIndices.length,
        (index) => tracker1.logs
            .elementAt(tracker1MatchingLogIndices.elementAt(index)));
    List<Log> tracker2MatchingLogs = List.generate(
        tracker2MatchingLogIndices.length,
        (index) => tracker1.logs
            .elementAt(tracker2MatchingLogIndices.elementAt(index)));

    List<int> tracker1MatchingLogValuesAsInt =
        convertBooleanLogValuesToInt(tracker1MatchingLogs);
    List<int> tracker2MatchingLogValuesAsInt =
        convertBooleanLogValuesToInt(tracker2MatchingLogs);

    double correlation = computeCorrelationWithListsOfNumbers(
        tracker1MatchingLogValuesAsInt, tracker2MatchingLogValuesAsInt);

    return correlation;
  }

  /// Converts the Boolean log values in the given list of binary logs to a list
  /// of integers, where 'true' -> 1 and 'false' -> 0.
  List<int> convertBooleanLogValuesToInt(List<Log> logs) {
    List<int> logValuesAsInt = [];
    logs.forEach((log) => logValuesAsInt.add(mapBoolToInt(log.value)));
    return logValuesAsInt;
  }

  int mapBoolToInt(bool booleanValue) {
    if (booleanValue == true) {
      return 1;
    } else {
      return 0;
    }
  }

  /// Returns a list of two lists, where both lists contain the indices of the
  /// logs in the first and second list that have the same time stamp dates,
  /// respectively.
  List<List<int>> getIndicesOfLogsAddedOnTheSameDay(
      List<Log> logs1, List<Log> logs2) {
    List<DateTime> logDates1 = [];
    logs1
        .forEach((log) => logDates1.add(convertTimeStampToDate(log.timeStamp)));
    List<DateTime> logDates2 = [];
    logs2
        .forEach((log) => logDates2.add(convertTimeStampToDate(log.timeStamp)));

    List<int> logs1MatchingIndices = [];
    List<int> logs2MatchingIndices = [];
    for (int idx1 = 0; idx1 < logDates1.length; idx1++) {
      for (int idx2 = 1; idx2 < logDates2.length; idx2++) {
        if (logDates1.elementAt(idx1) == logDates2.elementAt(idx2)) {
          logs1MatchingIndices.add(idx1);
          logs2MatchingIndices.add(idx2);
        }
      }
    }
    return [logs1MatchingIndices, logs2MatchingIndices];
  }

  /// Throws an exception if there logs of the given tracker that were added
  /// on the same day (only one log is allowed per day).
  void checkIfMultipleLogsOnSameDay(Tracker tracker) {
    List<DateTime> datesOfTimeStamps = [];
    tracker.logs.forEach(
        (log) => datesOfTimeStamps.add(convertTimeStampToDate(log.timeStamp)));
    bool notAllDatesUnique =
        datesOfTimeStamps.toSet().length != tracker.logs.length;
    if (notAllDatesUnique) {
      throw ('Found a tracker whose logs are not all from different dates.');
    }
  }

  DateTime convertTimeStampToDate(DateTime timeStamp) {
    int year = timeStamp.year;
    int month = timeStamp.month;
    int day = timeStamp.day;
    return DateTime(month = month, day = day, year = year);
  }

  double computeCorrelationWithListsOfNumbers(List x, List y) {
    // TODO: check with examples whether this function works
    if (x.length != y.length) {
      throw ('Input lists must have the same length.');
    }
    if (x.isEmpty || y.isEmpty) {
      throw ('Lists must not be empty.');
    }

    var meanX = sum(x) / x.length;
    var meanY = sum(y) / y.length;

    List xValuesMinusMean = x.map((value) => value - meanX).toList();
    List yValuesMinusMean = x.map((value) => value - meanY).toList();

    var sumOfProducts = 0;
    for (int i = 0; i < xValuesMinusMean.length; i++) {
      sumOfProducts +=
          xValuesMinusMean.elementAt(i) * yValuesMinusMean.elementAt(i);
    }
    var numerator = sumOfProducts;

    double xValuesMinusMeanSumOfSquares =
        sum(xValuesMinusMean.map((value) => value * value).toList());
    double yValuesMinusMeanSumOfSquares =
        sum(yValuesMinusMean.map((value) => value * value).toList());
    double denominator =
        sqrt(xValuesMinusMeanSumOfSquares * yValuesMinusMeanSumOfSquares);

    double correlationCoefficient = numerator / denominator;
    return correlationCoefficient;
  }

  double sum(List numbers) {
    return numbers.reduce((value, element) => value + element);
  }

  /// Returns a map, with two key-value pairs where the keys are strings and the
  /// values lists. One key-value pair contains the correlations
  /// descendingly ordered by their absolute value. The other key-value pair
  /// contains the names of the trackers corresponding to the sorted
  /// correlation coefficients.
  ///
  /// Input arguments:
  /// correlationsBetweenTrackers -- list of correlations between two trackers
  /// trackerNames -- list of tracker names, where each name corresponds to
  ///                 the tracker that was used to compute the correlation with
  ///                 the same index in 'correlationsBetweenTrackers'
  Map sortCorrelationsByMagnitudeAndSortTrackerNamesAccordingly(
      List<double> correlationsBetweenTrackers, List<String> trackerNames) {
    int compareAbsoluteValue(int a, int b) {
      if (a.abs() > b.abs()) {
        return 1;
      } else if (a.abs() < b.abs()) {
        return -1;
      } else {
        return 0;
      }
    }

    List correlationsWithIndex = List.generate(
        correlationsBetweenTrackers.length,
        (index) => [correlationsBetweenTrackers[index], index]);
    correlationsWithIndex.sort((a, b) => compareAbsoluteValue(a[1], b[1]));

    List<String> sortedTrackerNames = List.generate(
        correlationsWithIndex.length,
        (index) => trackerNames[correlationsWithIndex[index][1]]);
    List<double> sortedCorrelations = List.generate(
        correlationsWithIndex.length, (index) => correlationsWithIndex[index]);

    return {
      'correlations': sortedCorrelations,
      'trackerNames': sortedTrackerNames
    };
  }

  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;
    Tracker trackerCorrespondingToLogs =
        listOfTrackers.singleWhere((tracker) => tracker.name == trackerName);

    if (trackerCorrespondingToLogs.logs.isNotEmpty) {
      Map trackersOrderedByMagnitudeOfCorrelation =
          getCorrelationsWithOtherTrackersOrderedByMagnitude(context);
      List<double> sortedCorrelations =
          trackersOrderedByMagnitudeOfCorrelation['correlations'];
      List<double> trackerNames =
          trackersOrderedByMagnitudeOfCorrelation['trackerNames'];

      // TODO: use list of listtiles here where each list tile contains the tracker name and the correlation
      return ListView(
        children: List<Widget>.generate(sortedCorrelations.length,
            (index) => Text(sortedCorrelations[index].toString())),
      );
      // TODO: would be nice to display how many values the correlation was computed with
      // TODO: is it possible to give some kind of 'confidence' about the correlation based on the number of samples? If yes, do that
    } else {
      return Text('ordered correlations with other trackers');
    }
  }
  // TODO: SIMPLIFY STATEMENTS WITH ELEMENT_AT & USE MAP INSTEAD OF LIST OF LISTS
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
  String chosenPeriod =
      'Day'; // the period with which the statistics will be calculated
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
