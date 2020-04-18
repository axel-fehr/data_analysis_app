/// Contains functions necessary to compute correlations between trackers
/// (regardless of their type).

import 'dart:math';

import '../classes/tracker.dart';
import '../classes/log.dart';

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
  List<int> tracker1MatchingLogIndices = sameDateLogsIndices[0];
  List<int> tracker2MatchingLogIndices = sameDateLogsIndices[1];

  List<Log> tracker1MatchingLogs = List.generate(
      tracker1MatchingLogIndices.length,
      (index) => tracker1.logs[tracker1MatchingLogIndices[index]]);
  List<Log> tracker2MatchingLogs = List.generate(
      tracker2MatchingLogIndices.length,
      (index) => tracker1.logs[tracker2MatchingLogIndices[index]]);

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
    for (int idx2 = 1; idx2 < logDates2.length; idx2++) {
      if (logDates1[idx1] == logDates2[idx2]) {
        logs1MatchingIndices.add(idx1);
        logs2MatchingIndices.add(idx2);
      }
    }
  }
  return [logs1MatchingIndices, logs2MatchingIndices];
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
    sumOfProducts += xValuesMinusMean[i] * yValuesMinusMean[i];
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

  List correlationsWithIndex = List.generate(correlationsBetweenTrackers.length,
      (index) => [correlationsBetweenTrackers[index], index]);
  correlationsWithIndex.sort((a, b) => compareAbsoluteValue(a[1], b[1]));

  List<String> sortedTrackerNames = List.generate(correlationsWithIndex.length,
      (index) => trackerNames[correlationsWithIndex[index][1]]);
  List<double> sortedCorrelations = List.generate(
      correlationsWithIndex.length, (index) => correlationsWithIndex[index]);

  return {
    'correlations': sortedCorrelations,
    'trackerNames': sortedTrackerNames
  };
}
