/// Contains functions necessary to compute correlations between trackers
/// (regardless of their type).

import 'dart:math';

import '../../classes/tracker.dart';
import '../../classes/log.dart';
import '../general.dart';
import '../math_utils.dart';

/// Computes the Pearson correlation coefficient between the logs of the two
/// given trackers.
///
/// The coefficient is only computed with logs where a log with the same time
/// stamp date can also be found in the other tracker. The remaining logs are
/// ignored.
double computePearsonCorrelationBetweenTwoTrackers(
    Tracker tracker1, Tracker tracker2) {
  assert(tracker1.logs.isNotEmpty && tracker2.logs.isNotEmpty,
      'Both trackers must have logs.');

  List<List<double>> valuesOfMatchingLogs = getLogValuesFromTheSameDate(
    tracker1,
    tracker2,
  );
  List<double> tracker1LogValues = valuesOfMatchingLogs[0];
  List<double> tracker2LogValues = valuesOfMatchingLogs[1];

  double correlation = computePearsonCorrelationWithListsOfNumbers(
    tracker1LogValues,
    tracker2LogValues,
  );

  return correlation;
}

/// Computes the Spearman correlation coefficient between the logs of the two
/// given trackers.
///
/// The coefficient is only computed with logs where a log with the same time
/// stamp date can also be found in the other tracker. The remaining logs are
/// ignored.
double computeSpearmanCorrelationBetweenTwoTrackers(
    Tracker tracker1, Tracker tracker2) {
  assert(tracker1.logs.isNotEmpty && tracker2.logs.isNotEmpty,
      'Both trackers must have logs.');

  List<List<double>> valuesOfMatchingLogs = getLogValuesFromTheSameDate(
    tracker1,
    tracker2,
  );
  List<double> tracker1LogValues = valuesOfMatchingLogs[0];
  List<double> tracker2LogValues = valuesOfMatchingLogs[1];

  Map<double, double> valueToRankMapOfTracker1 = rankValues(tracker1LogValues);
  Map<double, double> valueToRankMapOfTracker2 = rankValues(tracker2LogValues);

  List<double> logValueRanksTracker1 = List.generate(
    tracker1LogValues.length,
    (index) => valueToRankMapOfTracker1[tracker1LogValues[index]],
  );
  List<double> logValueRanksTracker2 = List.generate(
    tracker2LogValues.length,
    (index) => valueToRankMapOfTracker2[tracker2LogValues[index]],
  );

  double correlation = computePearsonCorrelationWithListsOfNumbers(
    logValueRanksTracker1,
    logValueRanksTracker2,
  );

  return correlation;
}

/// Returns a list of two lists of equal length, where values with the same
/// index in the two lists are values from logs that were added on the same
/// date.
///
/// The first and the second list correspond to the log values for the first
/// and second input argument, respectively.
/// The log values are always cast to doubles (false is mapped to 0.0 and true
/// is mapped to 1.0 in the case of Boolean log values).
List<List<double>> getLogValuesFromTheSameDate(
    Tracker tracker1, Tracker tracker2) {
  List<List<int>> sameDateLogsIndices =
      getIndicesOfLogsAddedOnTheSameDate(tracker1.logs, tracker2.logs);
  List<int> tracker1MatchingLogIndices = sameDateLogsIndices[0];
  List<int> tracker2MatchingLogIndices = sameDateLogsIndices[1];

  List<Log> tracker1MatchingLogs = List.generate(
      tracker1MatchingLogIndices.length,
      (index) => tracker1.logs[tracker1MatchingLogIndices[index]]);
  List<double> tracker1LogValues = getLogValuesAsDoubles(tracker1MatchingLogs);

  List<Log> tracker2MatchingLogs = List.generate(
      tracker2MatchingLogIndices.length,
      (index) => tracker2.logs[tracker2MatchingLogIndices[index]]);
  List<double> tracker2LogValues = getLogValuesAsDoubles(tracker2MatchingLogs);

  return [tracker1LogValues, tracker2LogValues];
}

/// Returns the values of logs in the given list of logs as a list of doubles.
///
/// If the log values are Boolean, [true] is converted to [1.0] and [false] is
/// converted to [0.0].
/// An error is thrown if the logs in the given list are not all of the same
/// type.
List<double> getLogValuesAsDoubles(List<Log> logs) {
  assert(logsAreAllOfTheSameType(logs),
      'The logs in the given list are not all of the same type');

  Type logTypeOfAllLogsInList = logs[0].value.runtimeType;

  if (logTypeOfAllLogsInList == double) {
    return List.generate(logs.length, (index) => logs[index].value);
  } else if (logTypeOfAllLogsInList == int) {
    return List.generate(logs.length, (index) => logs[index].value.toDouble());
  } else if (logTypeOfAllLogsInList == bool) {
    List<Log<bool>> typeSafeLogs =
        List.generate(logs.length, (index) => logs[index]);
    return convertBooleanLogValuesToNumbers(typeSafeLogs);
  } else {
    throw ArgumentError(
        'Unexpected log type encountered: $logTypeOfAllLogsInList');
  }
}

/// Returns a Boolean value that indicates if the logs in the given list are all
/// of the same type.
bool logsAreAllOfTheSameType(List<Log> logs) {
  Type logTypeOfFirstLog = logs[0].value.runtimeType;
  for (int i = 1; i < logs.length; i++) {
    if (logs[i].value.runtimeType != logTypeOfFirstLog) {
      return false;
    }
  }
  return true;
}

/// Converts the Boolean log values in the given list of logs to a list
/// of doubles, where 'true' -> 1.0 and 'false' -> 0.0
List<double> convertBooleanLogValuesToNumbers(List<Log<bool>> logs) {
  List<double> logValuesAsNumbers = [];
  logs.forEach((log) => logValuesAsNumbers.add(mapBoolToDouble(log.value)));
  return logValuesAsNumbers;
}

double mapBoolToDouble(bool booleanValue) {
  if (booleanValue == true) {
    return 1.0;
  } else {
    return 0.0;
  }
}

/// Returns a list of two lists, where both lists contain the indices of the
/// logs in the first and second list that have the same time stamp dates,
/// respectively.
List<List<int>> getIndicesOfLogsAddedOnTheSameDate(
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

/// Returns a map that maps a value from the given list to a rank (i.e. the keys
/// are the values and the values are the ranks).
///
/// All ranks are greater than 0. The smaller values in the list get a lower
/// rank than higher values. If a value occurs more than once in the given list,
/// a fractional rank is computed (i.e. the mean rank of the elements with the
/// given value).
Map<double, double> rankValues(List<double> values) {
  assert(values.isNotEmpty, 'List of values must not be empty');

  // sorts the values in ascending order
  List<double> sortedValues = List.from(values);
  sortedValues.sort();

  List<double> uniqueValues = sortedValues.toSet().toList();

  Map<double, double> valueToRankMap = {};

  /// Saves the index of the last value for which the rank was computed.
  /// This is needed to compute the rank correctly for fractional ranks.
  /// -1 indicates that the rank has not been computed for any value yet.
  int indexOfLastValueForWhichRankWasComputed = -1;

  uniqueValues.forEach((uniqueValue) {
    List<double> matchingValues =
        sortedValues.where((value) => value == uniqueValue).toList();
    if (matchingValues.length == 1) {
      int rank = sortedValues.indexOf(uniqueValue) + 1;
      valueToRankMap[uniqueValue] = rank.toDouble();
      indexOfLastValueForWhichRankWasComputed = rank - 1;
    } else {
      // computes a fractional rank for the values that occur more than once
      List<double> ranksOfEqualValues = List.generate(
          matchingValues.length,
          (index) =>
              indexOfLastValueForWhichRankWasComputed + 2 + index.toDouble());
      double fractionalRank = mean(ranksOfEqualValues);
      valueToRankMap[uniqueValue] = fractionalRank;
      indexOfLastValueForWhichRankWasComputed =
          sortedValues.lastIndexOf(uniqueValue);
    }
  });

  return valueToRankMap;
}

double computePearsonCorrelationWithListsOfNumbers(
    List<double> x, List<double> y) {
  if (x.length != y.length) {
    throw ArgumentError('Input lists must have the same length.');
  }
  if (x.isEmpty || y.isEmpty) {
    throw ArgumentError('Lists must not be empty.');
  }

  double meanX = sum(x) / x.length;
  double meanY = sum(y) / y.length;

  List<double> xValuesMinusMean = x.map((value) => value - meanX).toList();
  List<double> yValuesMinusMean = y.map((value) => value - meanY).toList();

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
