import 'package:test/test.dart';

import 'package:tracking_app/classes/log.dart';
import 'package:tracking_app/classes/tracker.dart';
import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show computeSpearmanCorrelationBetweenTwoTrackers;

void main() {
  test(
    'Throw argument error when trackers have no logs from the same day',
    () async {
      // Test 1
      Tracker tracker1 = Tracker<bool>(
        'tracker1',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2020, 4, 15)),
          Log<bool>(false, timeStamp: DateTime(2020, 4, 16)),
          Log<bool>(false, timeStamp: DateTime(2020, 4, 18)),
        ],
      );
      Tracker tracker2 = Tracker<bool>(
        'tracker2',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2019, 4, 16)),
          Log<bool>(true, timeStamp: DateTime(2020, 4, 17)),
          Log<bool>(true, timeStamp: DateTime(2020, 5, 18)),
        ],
      );

      expect(
          () =>
              computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2),
          throwsArgumentError);
      expect(
          () =>
              computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1),
          throwsArgumentError);

      // Test 2
      tracker1 = Tracker<int>(
        'tracker1',
        logs: [
          Log<int>(1, timeStamp: DateTime(2020, 4, 15)),
          Log<int>(2, timeStamp: DateTime(2020, 4, 16)),
          Log<int>(3, timeStamp: DateTime(2020, 4, 18)),
        ],
      );
      tracker2 = Tracker<double>(
        'tracker2',
        logs: [
          Log<double>(-0.4, timeStamp: DateTime(2019, 4, 16)),
          Log<double>(3.9, timeStamp: DateTime(2020, 4, 17)),
          Log<double>(67.3, timeStamp: DateTime(2020, 5, 18)),
        ],
      );

      expect(
          () =>
              computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2),
          throwsArgumentError);
      expect(
          () =>
              computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1),
          throwsArgumentError);
    },
  );

  test(
    'Correlation is NaN if there is only one pair of logs from the same day',
    () async {
      Tracker tracker1 = Tracker<double>(
        'tracker1',
        logs: [
          Log<double>(1, timeStamp: DateTime(2020, 4, 15)),
          Log<double>(2, timeStamp: DateTime(2020, 4, 16)),
        ],
      );
      Tracker tracker2 = Tracker<int>(
        'tracker2',
        logs: [
          Log<int>(1, timeStamp: DateTime(2020, 4, 15)),
          Log<int>(2, timeStamp: DateTime(2020, 4, 18)),
        ],
      );

      double correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      double correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.isNaN, true);
      expect(correlationWithReversedInput.isNaN, true);
    },
  );

  test(
    'Correlation coefficient must be NaN if the logs of at least one tracker '
    'that are used to compute the correlation all have the same value '
    '(because of division by zero)',
    () async {
      // Test 1
      Tracker tracker1 = Tracker<bool>(
        'tracker1',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2020, 1, 28)),
          Log<bool>(false, timeStamp: DateTime(2020, 1, 30)),
          Log<bool>(false, timeStamp: DateTime(2020, 1, 31)),
        ],
      );
      Tracker tracker2 = Tracker<bool>(
        'tracker2',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2020, 1, 29)),
          Log<bool>(true, timeStamp: DateTime(2020, 1, 30)),
          Log<bool>(false, timeStamp: DateTime(2020, 1, 31)),
        ],
      );

      double correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      double correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.isNaN, true);
      expect(correlationWithReversedInput.isNaN, true);

      // Test 2
      tracker1 = Tracker<double>(
        'tracker1',
        logs: [
          Log<double>(1.5, timeStamp: DateTime(2020, 1, 1)),
          Log<double>(1.5, timeStamp: DateTime(2020, 1, 2)),
        ],
      );
      tracker2 = Tracker<bool>(
        'tracker2',
        logs: [
          Log<bool>(false, timeStamp: DateTime(2019, 12, 31)),
          Log<bool>(true, timeStamp: DateTime(2020, 1, 1)),
          Log<bool>(true, timeStamp: DateTime(2020, 1, 2)),
        ],
      );

      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.isNaN, true);
      expect(correlationWithReversedInput.isNaN, true);

      // Test 3
      tracker1 = Tracker<bool>(
        'tracker1',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2019, 12, 31)),
          Log<bool>(true, timeStamp: DateTime(2020, 1, 1)),
        ],
      );
      tracker2 = Tracker<bool>(
        'tracker2',
        logs: [
          Log<bool>(true, timeStamp: DateTime(2019, 12, 31)),
          Log<bool>(true, timeStamp: DateTime(2020, 1, 1)),
        ],
      );

      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.isNaN, true);
      expect(correlationWithReversedInput.isNaN, true);
    },
  );

  test(
    'Correlation coefficient must be correct when it can be computed (i.e. '
    'when there are enough log pairs and where the log value mean is not '
    'equal to all the log values)',
    () async {
      // Test 1
      Tracker tracker1 = Tracker<int>(
        'tracker1',
        logs: [
          Log<int>(1, timeStamp: DateTime(2020, 1, 29)),
          Log<int>(2, timeStamp: DateTime(2020, 1, 30)),
          Log<int>(3, timeStamp: DateTime(2020, 1, 31)),
        ],
      );
      Tracker tracker2 = Tracker<int>(
        'tracker2',
        logs: [
          Log<int>(3, timeStamp: DateTime(2020, 1, 28)),
          Log<int>(2, timeStamp: DateTime(2020, 1, 30)),
          Log<int>(1, timeStamp: DateTime(2020, 1, 31)),
        ],
      );

      double correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      double correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation, -1.0);
      expect(correlationWithReversedInput, -1.0);

      // Test 2
      tracker1 = Tracker<double>(
        'tracker1',
        logs: [
          Log<double>(14.2, timeStamp: DateTime(2021, 10, 3)),
          Log<double>(-16.4, timeStamp: DateTime(2021, 10, 5)),
          Log<double>(11.9, timeStamp: DateTime(2021, 10, 18)),
        ],
      );
      tracker2 = Tracker<double>(
        'tracker2',
        logs: [
          Log<double>(2.15, timeStamp: DateTime(2021, 10, 3)),
          Log<double>(32.5, timeStamp: DateTime(2021, 10, 5)),
          Log<double>(18.5, timeStamp: DateTime(2021, 10, 18)),
          Log<double>(3.0, timeStamp: DateTime(2021, 11, 2)),
        ],
      );

      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation, -1.0);
      expect(correlationWithReversedInput, -1.0);

      // Test 3
      tracker1 = Tracker<int>(
        'tracker1',
        logs: [
          Log<int>(3, timeStamp: DateTime(2019, 10, 3)),
          Log<int>(1, timeStamp: DateTime(2019, 10, 4)),
          Log<int>(-16, timeStamp: DateTime(2019, 10, 5)),
          Log<int>(-7, timeStamp: DateTime(2019, 10, 6)),
          Log<int>(2, timeStamp: DateTime(2019, 11, 18)),
          Log<int>(11, timeStamp: DateTime(2019, 11, 2)),
        ],
      );
      tracker2 = Tracker<double>(
        'tracker2',
        logs: [
          Log<double>(3.5, timeStamp: DateTime(2019, 10, 4)),
          Log<double>(2.15, timeStamp: DateTime(2019, 10, 5)),
          Log<double>(0.2, timeStamp: DateTime(2019, 11, 18)),
          Log<double>(5.1, timeStamp: DateTime(2019, 10, 24)),
          Log<double>(18.5, timeStamp: DateTime(2019, 11, 2)),
        ],
      );

      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation, 0.4);
      expect(correlationWithReversedInput, 0.4);

      // Test 4
      tracker1 = Tracker<int>(
        'tracker1',
        logs: [
          Log<int>(1, timeStamp: DateTime(2021, 10, 3)),
          Log<int>(2, timeStamp: DateTime(2021, 10, 4)),
          Log<int>(3, timeStamp: DateTime(2021, 10, 5)),
          Log<int>(2, timeStamp: DateTime(2021, 10, 18)),
          Log<int>(0, timeStamp: DateTime(2021, 11, 2)),
          Log<int>(3, timeStamp: DateTime(2021, 11, 3)),
        ],
      );
      tracker2 = Tracker<int>(
        'tracker2',
        logs: [
          Log<int>(1, timeStamp: DateTime(2021, 10, 4)),
          Log<int>(2, timeStamp: DateTime(2021, 10, 5)),
          Log<int>(2, timeStamp: DateTime(2021, 10, 18)),
          Log<int>(3, timeStamp: DateTime(2021, 11, 2)),
          Log<int>(3, timeStamp: DateTime(2021, 11, 3)),
        ],
      );

      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.toStringAsFixed(5), '-0.02778');
      expect(correlationWithReversedInput.toStringAsFixed(5), '-0.02778');

      // Test 5
      tracker1 = Tracker<double>(
        'tracker1',
        logs: [
          Log<double>(8, timeStamp: DateTime(2019, 10, 2)),
          Log<double>(7.5, timeStamp: DateTime(2019, 10, 3)),
          Log<double>(7.8, timeStamp: DateTime(2019, 10, 4)),
          Log<double>(7.5, timeStamp: DateTime(2019, 10, 6)),
          Log<double>(8, timeStamp: DateTime(2019, 11, 18)),
          Log<double>(7.5, timeStamp: DateTime(2019, 11, 19)),
          Log<double>(8.5, timeStamp: DateTime(2019, 11, 20)),
          Log<double>(7.5, timeStamp: DateTime(2019, 11, 21)),
        ],
      );
      tracker2 = Tracker<int>(
        'tracker2',
        logs: [
          Log<int>(2, timeStamp: DateTime(2019, 10, 4)),
          Log<int>(2, timeStamp: DateTime(2019, 10, 5)),
          Log<int>(2, timeStamp: DateTime(2019, 10, 6)),
          Log<int>(0, timeStamp: DateTime(2019, 11, 18)),
          Log<int>(2, timeStamp: DateTime(2019, 11, 19)),
          Log<int>(1, timeStamp: DateTime(2019, 11, 20)),
          Log<int>(2, timeStamp: DateTime(2019, 11, 21)),
        ],
      );
      correlation =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker1, tracker2);
      correlationWithReversedInput =
          computeSpearmanCorrelationBetweenTwoTrackers(tracker2, tracker1);

      expect(correlation.toStringAsFixed(5), '-0.82618');
      expect(correlationWithReversedInput.toStringAsFixed(5), '-0.82618');
    },
  );
}
