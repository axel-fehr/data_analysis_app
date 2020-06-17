import 'package:test/test.dart';

import 'package:tracking_app/utils/math_utils.dart' show mode;

void main() {
  test(
    'Throw argument error when input list is empty.',
    () {
      List<int> inputList = [];
      expect(() => mode(inputList), throwsArgumentError);
    },
  );

  test(
    'The mode of a list of numbers where all elements occur only once should '
    'be an empty list, since the mode does not exist in such a case.',
    () {
      // Test 1
      List<int> inputList = [1];
      List<int> result = mode(inputList);
      expect(result, []);

      // Test 2
      inputList = [-1, 0, 1];
      result = mode(inputList);
      expect(result, []);

      // Test 3
      inputList = [1, 2, 3, 4, 5];
      result = mode(inputList);
      expect(result, []);
    },
  );

  test(
    'The returned list should contain the most common element in the input '
    'list.',
    () {
      // Test 1
      List<int> inputList = [1, 2, 2, 3];
      List<int> result = mode(inputList);
      expect(result, [2]);

      // Test 2
      inputList = [-3, 0, -5, 1, 0];
      result = mode(inputList);
      expect(result, [0]);

      // Test 3
      inputList = [1, 0, 2, 3, 0, 1, 3, 1];
      result = mode(inputList);
      expect(result, [1]);
    },
  );

  test(
    'The returned list of should contain the multiple elements sorted in '
    'ascending order if there are multiple elements whose number '
    'of occurrences is the highest number of occurrences of any element in'
    'the list.',
    () {
      // Test 1
      List<int> inputList = [1, 2, 2, 1, 3];
      List<int> result = mode(inputList);
      expect(result, [1, 2]);

      // Test 2
      inputList = [-3, 0, 0, -5, -3, 1, 0, -3];
      result = mode(inputList);
      expect(result, [-3, 0]);

      // Test 3
      inputList = [1, 2, 3, 4, 5, 1, 2, 3, 3, 2, 1, 4];
      result = mode(inputList);
      expect(result, [1, 2, 3]);
    },
  );
}
