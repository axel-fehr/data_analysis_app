import 'package:test/test.dart';

import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show computeCorrelationWithListsOfNumbers;

void main() {
  test('Correlation must be computed correctly with List<double>', () {
    List<double> listOfNumbers1 = [2.2, 1.0];
    List<double> listOfNumbers2 = [3.5, -1.7];

    double correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient, 1.0);

    listOfNumbers1 = [14.2, -16.4, 11.9, 15.2];
    listOfNumbers2 = [2.1, 32.5, -1.8, 3.3];

    correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfNumbers1, listOfNumbers2);
    expect(correlationCoefficient.toStringAsFixed(4), '-0.9738');
  });

  test('Correlation must be computed correctly with List<int>', () {
    List<int> listOfNumbers1 = [2, -1];
    List<int> listOfNumbers2 = [-4, 5];

    double correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient, -1.0);

    listOfNumbers1 = [0, 6, 1];
    listOfNumbers2 = [10, -2, 12];

    correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient.toStringAsFixed(5), '-0.95863');
  });

  test(
      'Correlation coefficient should be nan if if only one number pair is given',
      () {
    List<int> listOfInts1 = [2];
    List<int> listOfInts2 = [-4];

    double correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfInts1, listOfInts2);

    expect(correlationCoefficient.isNaN, true);

    List<double> listOfNumbers1 = [2.3];
    List<double> listOfNumbers2 = [3.5];

    correlationCoefficient =
        computeCorrelationWithListsOfNumbers(listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient.isNaN, true);
  });

  test('Should throw error if input lists are not of the same length', () {
    List<int> listOfInts1 = [2, 4];
    List<int> listOfInts2 = [-4];

    expect(() => computeCorrelationWithListsOfNumbers(listOfInts1, listOfInts2),
        throwsArgumentError);
  });

  test('Should throw error if at least one of the input lists is empty', () {
    List<int> listOfInts1 = [];
    List<int> listOfInts2 = [-4];

    expect(() => computeCorrelationWithListsOfNumbers(listOfInts1, listOfInts2),
        throwsArgumentError);

    listOfInts1 = [3, 4];
    listOfInts2 = [];

    expect(() => computeCorrelationWithListsOfNumbers(listOfInts1, listOfInts2),
        throwsArgumentError);

    listOfInts1 = [];
    listOfInts2 = [];

    expect(() => computeCorrelationWithListsOfNumbers(listOfInts1, listOfInts2),
        throwsArgumentError);
  });
}