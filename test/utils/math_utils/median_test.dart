import 'package:test/test.dart';

import 'package:tracking_app/utils/math_utils.dart' show median;

void main() {
  test(
    'Throw argument error when input list is empty.',
        () {
      List<double> inputList = [];
      expect(() => median(inputList), throwsArgumentError);
    },
  );

  test(
    'Throw argument error when input list contains only one number.',
        () {
      List<double> inputList = [1.5];
      expect(() => median(inputList), throwsArgumentError);
    },
  );

  test(
    'The median of a list with an odd number of elements should be the number '
        'in the middle of the sorted list.',
        () {
      // Test 1
      List<double> inputList = [1,2,3];
      double result = median(inputList);
      expect(result, 2);

      // Test 2
      inputList = [2,3,1];
      result = median(inputList);
      expect(result, 2);

      // Test 3
      inputList = [-5.5, 100, 6.25, 0.2, -3.2];
      result = median(inputList);
      expect(result, 0.2);
    },
  );

  test(
    'The median of a list with an even number of elements should be the mean '
        'of the two middle values in the sorted list.',
        () {
      // Test 1
      List<double> inputList = [-1.5, 0.5];
      double result = median(inputList);
      expect(result, -0.5);

      // Test 2
      inputList = [0, 1, 3, 5];
      result = median(inputList);
      expect(result, 2);

      // Test 3
      inputList = [2.5, -1.5, 2.0, 10];
      result = median(inputList);
      expect(result, 2.25);
    },
  );
}
