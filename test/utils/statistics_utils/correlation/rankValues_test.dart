import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show rankValues;

void main() {
  test(
    'Throw assertion error when input list is empty',
    () {
      expect(() => rankValues([]), throwsAssertionError);
    },
  );

  test(
    'Value in input list with one single value should have the ranking 1',
    () async {
      expect(rankValues([4.2]), {4.2: 1.0});
    },
  );

  test(
    'Multiple unique values should be ranked in ascending order',
    () async {
      // Test 1
      List<double> testInput = [4.2, 0.0];
      Map<double, double> output = rankValues(testInput);
      expect(output[0.0], 1.0);
      expect(output[4.2], 2.0);
      expect(output.keys.toList().length, 2);

      // Test 2
      testInput = [1.2, -1.7, 0.0];
      output = rankValues(testInput);
      expect(output[1.2], 3.0);
      expect(output[-1.7], 1.0);
      expect(output[0.0], 2.0);
      expect(output.keys.toList().length, 3);
    },
  );

  test(
    'Values occurring more than once in the input list have a fractional rank',
        () async {
      // Test 1
      List<double> testInput = [3.5, 3.5];
      Map<double, double> output = rankValues(testInput);
      expect(output[3.5], 1.5);
      expect(output.keys.toList().length, 1);

      // Test 2
      testInput = [2, 1, 2, 2];
      output = rankValues(testInput);
      expect(output[1], 1.0);
      expect(output[2], 3.0);
      expect(output.keys.toList().length, 2);

      // Test 3
      testInput = [2, 1, 2, 2, 1, 2];
      output = rankValues(testInput);
      expect(output[1], 1.5);
      expect(output[2], 4.5);
      expect(output.keys.toList().length, 2);

      // Test 4
      testInput = [-3, 5, 0, 5, 0, 6, 0];
      output = rankValues(testInput);
      expect(output[-3], 1.0);
      expect(output[0], 3.0);
      expect(output[5], 5.5);
      expect(output[6], 7.0);
      expect(output.keys.toList().length, 4);
    },
  );
}
