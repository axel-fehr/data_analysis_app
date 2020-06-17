import 'package:test/test.dart';

import 'package:tracking_app/utils/math_utils.dart' show sum;

void main() {
  test(
    'Throw state error when input list is empty.',
        () {
      List<double> inputList = [];
      expect(() => sum(inputList), throwsStateError);
    },
  );

  test(
    'Summing up a list with one element should return that element.',
        () {
      List<double> inputList = [2.5];
      double result = sum(inputList);
      expect(result, 2.5);
    },
  );

  test(
    'The sum of multiple elements must be correct.',
        () {
      List<double> inputList = [2.5, -1.5, 0.0];
      double result = sum(inputList);
      expect(result, 1);
    },
  );
}
