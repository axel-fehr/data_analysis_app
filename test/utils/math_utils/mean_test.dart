import 'package:test/test.dart';

import 'package:tracking_app/utils/math_utils.dart' show mean;

void main() {
  test(
    'Throw state error when input list is empty.',
        () {
      List<double> inputList = [];
      expect(() => mean(inputList), throwsStateError);
    },
  );

  test(
    'The mean of a list with one number should be the number itself.',
        () {
      List<double> inputList = [10];
      double result = mean(inputList);
      expect(result, 10);
    },
  );

  test(
    'The mean of multiple elements must be correct.',
        () {
      // Test 1
      List<double> inputList = [2.5, -1.5, 2.0];
      double result = mean(inputList);
      expect(result, 1.0);

      // Test 2
      inputList = [-5.5, -6.8, 0.0, 0.3];
      result = mean(inputList);
      expect(result, -3.0);
    },
  );
}
