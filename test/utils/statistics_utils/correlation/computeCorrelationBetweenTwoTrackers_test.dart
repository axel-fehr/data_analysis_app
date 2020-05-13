import 'package:flutter/cupertino.dart';
import 'package:test/test.dart';

import 'package:tracking_app/classes/log.dart';
import 'package:tracking_app/classes/tracker.dart';
import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show computeCorrelationBetweenTwoTrackers;

void main() {
  test('Throw argument error when trackers have no logs from the same day',
      () async {
    Tracker tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 4, 15)),
        Log(false, timeStamp: DateTime(2020, 4, 16)),
        Log(false, timeStamp: DateTime(2020, 4, 18)),
      ],
    );
    Tracker tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2019, 4, 16)),
        Log(true, timeStamp: DateTime(2020, 4, 17)),
        Log(true, timeStamp: DateTime(2020, 5, 18)),
      ],
    );

    expect(() => computeCorrelationBetweenTwoTrackers(tracker1, tracker2),
        throwsArgumentError);
    expect(() => computeCorrelationBetweenTwoTrackers(tracker2, tracker1),
        throwsArgumentError);
  });

  test('Correlation is NaN if there is only one pair of logs from the same day',
      () async {
    Tracker tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 4, 15)),
        Log(false, timeStamp: DateTime(2020, 4, 16)),
      ],
    );
    Tracker tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 4, 15)),
        Log(true, timeStamp: DateTime(2020, 4, 18)),
      ],
    );

    double correlation =
        computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    double correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation.isNaN, true);
    expect(correlationWithReversedInput.isNaN, true);
  });

  test(
      'Correlation coefficient must be NaN if the logs of at least one tracker '
      'that are used to compute the correlation all have the same value '
      '(because of division by zero)', () async {
    // Test 1
    Tracker tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 1, 28)),
        Log(false, timeStamp: DateTime(2020, 1, 30)),
        Log(false, timeStamp: DateTime(2020, 1, 31)),
      ],
    );
    Tracker tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 1, 29)),
        Log(true, timeStamp: DateTime(2020, 1, 30)),
        Log(false, timeStamp: DateTime(2020, 1, 31)),
      ],
    );

    double correlation =
        computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    double correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation.isNaN, true);
    expect(correlationWithReversedInput.isNaN, true);

    // Test 2
    tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(false, timeStamp: DateTime(2020, 1, 1)),
        Log(true, timeStamp: DateTime(2020, 1, 2)),
      ],
    );
    tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(false, timeStamp: DateTime(2019, 12, 31)),
        Log(true, timeStamp: DateTime(2020, 1, 1)),
        Log(true, timeStamp: DateTime(2020, 1, 2)),
      ],
    );

    correlation = computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation.isNaN, true);
    expect(correlationWithReversedInput.isNaN, true);

    // Test 3
    tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2019, 12, 31)),
        Log(true, timeStamp: DateTime(2020, 1, 1)),
      ],
    );
    tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2019, 12, 31)),
        Log(true, timeStamp: DateTime(2020, 1, 1)),
      ],
    );

    correlation = computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation.isNaN, true);
    expect(correlationWithReversedInput.isNaN, true);
  });

  test(
      'Correlation coefficient must be correct when it can be computed (i.e. '
      'when there are enough log pairs and where the log value mean is not '
      'equal to all the log values)', () async {
    // Test 1
    Tracker tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 1, 29)),
        Log(false, timeStamp: DateTime(2020, 1, 30)),
        Log(true, timeStamp: DateTime(2020, 1, 31)),
      ],
    );
    Tracker tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2020, 1, 28)),
        Log(true, timeStamp: DateTime(2020, 1, 30)),
        Log(false, timeStamp: DateTime(2020, 1, 31)),
      ],
    );

    double correlation =
        computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    double correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation, -1.0);
    expect(correlationWithReversedInput, -1.0);

    // Test 2
    tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2019, 12, 31)),
        Log(false, timeStamp: DateTime(2020, 1, 1)),
        Log(false, timeStamp: DateTime(2020, 1, 2)),
      ],
    );
    tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2019, 12, 31)),
        Log(false, timeStamp: DateTime(2020, 1, 1)),
        Log(true, timeStamp: DateTime(2020, 1, 2)),
        Log(false, timeStamp: DateTime(2020, 1, 3)),
      ],
    );

    correlation = computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation, 0.5);
    expect(correlationWithReversedInput, 0.5);

    // Test 3
    tracker1 = Tracker(
      'tracker1',
      'Boolean',
      logs: [
        Log(false, timeStamp: DateTime(2021, 10, 3)),
        Log(true, timeStamp: DateTime(2021, 10, 4)),
        Log(false, timeStamp: DateTime(2021, 10, 5)),
        Log(false, timeStamp: DateTime(2021, 10, 18)),
        Log(true, timeStamp: DateTime(2021, 11, 2)),
      ],
    );
    tracker2 = Tracker(
      'tracker2',
      'Boolean',
      logs: [
        Log(true, timeStamp: DateTime(2021, 10, 3)),
        Log(false, timeStamp: DateTime(2021, 10, 5)),
        Log(true, timeStamp: DateTime(2021, 10, 18)),
        Log(false, timeStamp: DateTime(2021, 11, 2)),
      ],
    );

    correlation = computeCorrelationBetweenTwoTrackers(tracker1, tracker2);
    correlationWithReversedInput =
        computeCorrelationBetweenTwoTrackers(tracker2, tracker1);

    expect(correlation.toStringAsFixed(5), '-0.57735');
    expect(correlationWithReversedInput.toStringAsFixed(5), '-0.57735');
  });
}
