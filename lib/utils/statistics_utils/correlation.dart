/// Contains functions necessary to compute correlations between trackers
/// (regardless of their type).

import 'dart:math';

import '../../classes/tracker.dart';
import '../../classes/log.dart';
import '../general.dart';

/// Computes the correlation coefficient between the logs of the two given
/// trackers.
///
/// The coefficient is only computed with logs where a log with the same time
/// stamp date can also be found in the other tracker. The remaining logs are
/// ignored.
double computeCorrelationBetweenTwoTrackers(
    Tracker tracker1, Tracker tracker2) {
  assert(tracker1.logs.isNotEmpty && tracker2.logs.isNotEmpty,
      'Both trackers must have logs.');

  List<List<int>> sameDateLogsIndices =
      getIndicesOfLogsAddedOnTheSameDay(tracker1.logs, tracker2.logs);
  List<int> tracker1MatchingLogIndices = sameDateLogsIndices[0];
  List<int> tracker2MatchingLogIndices = sameDateLogsIndices[1];

  List<Log> tracker1MatchingLogs = List.generate(
      tracker1MatchingLogIndices.length,
      (index) => tracker1.logs[tracker1MatchingLogIndices[index]]);
  List<Log> tracker2MatchingLogs = List.generate(
      tracker2MatchingLogIndices.length,
      (index) => tracker2.logs[tracker2MatchingLogIndices[index]]);

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
  logs1.forEach((log) => logDates1.add(convertTimeStampToDate(log.timeStamp)));
  List<DateTime> logDates2 = [];
  logs2.forEach((log) => logDates2.add(convertTimeStampToDate(log.timeStamp)));

  List<int> logs1MatchingIndices = [];
  List<int> logs2MatchingIndices = [];
  for (int idx1 = 0; idx1 < logDates1.length; idx1++) {
    for (int idx2 = 0; idx2 < logDates2.length; idx2++) {
      if (logDates1[idx1] == logDates2[idx2]) {
        logs1MatchingIndices.add(idx1);
        logs2MatchingIndices.add(idx2);
      }
    }
  }
  return [logs1MatchingIndices, logs2MatchingIndices];
}

double computeCorrelationWithListsOfNumbers(List<num> x, List<num> y) {
  if (x.length != y.length) {
    throw ArgumentError('Input lists must have the same length.');
  }
  if (x.isEmpty || y.isEmpty) {
    throw ArgumentError('Lists must not be empty.');
  }

  List<double> typeSafeX = x is List<double>
      ? x
      : List.generate(x.length, (idx) => x[idx].toDouble());
  List<double> typeSafeY = x is List<double>
      ? y
      : List.generate(y.length, (idx) => y[idx].toDouble());

  double meanX = sum(typeSafeX) / x.length;
  double meanY = sum(typeSafeY) / y.length;

  List<double> xValuesMinusMean =
      typeSafeX.map((value) => value - meanX).toList();
  List<double> yValuesMinusMean =
      typeSafeY.map((value) => value - meanY).toList();

  double sumOfProducts = 0;
  for (int i = 0; i < xValuesMinusMean.length; i++) {
    sumOfProducts += xValuesMinusMean[i] * yValuesMinusMean[i];
  }
  double numerator = sumOfProducts;

  double xValuesMinusMeanSumOfSquares =
      sum(xValuesMinusMean.map((value) => value * value).toList());
  double yValuesMinusMeanSumOfSquares =
      sum(yValuesMinusMean.map((value) => value * value).toList());
  double denominator =
      sqrt(xValuesMinusMeanSumOfSquares * yValuesMinusMeanSumOfSquares);

  double correlationCoefficient = numerator / denominator;
  return correlationCoefficient;
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
Map<String, List> sortCorrelationsByMagnitudeAndSortTrackerNamesAccordingly(
    List<double> correlationsBetweenTrackers, List<String> trackerNames) {
  /// Returns a negative integer if [a] comes before [b] in the list, a positive
  /// integer if [b] comes before [a] and 0 if the order does not matter.
  int compareAbsoluteValue(double a, double b) {
    // handles nan values
    if (a.isNaN || b.isNaN) {
      if (a.isNaN && b.isNaN) {
        return 0;
      } else {
        return a.isNaN ? 1 : -1;
      }
    }

    // used for comparison when no nan values are present
    if (a.abs() > b.abs()) {
      return -1;
    } else if (a.abs() < b.abs()) {
      return 1;
    } else {
      return 0;
    }
  }

  List correlationsWithIndex = List.generate(correlationsBetweenTrackers.length,
      (index) => [correlationsBetweenTrackers[index], index]);
  correlationsWithIndex.sort((a, b) => compareAbsoluteValue(a[0], b[0]));

  List<String> sortedTrackerNames = List.generate(correlationsWithIndex.length,
      (index) => trackerNames[correlationsWithIndex[index][1]]);
  List<double> sortedCorrelations = List.generate(
      correlationsWithIndex.length, (index) => correlationsWithIndex[index][0]);

  return {
    'correlations': sortedCorrelations,
    'trackerNames': sortedTrackerNames
  };
}
