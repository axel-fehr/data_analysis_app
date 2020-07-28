import 'package:test/test.dart';

import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show computePearsonCorrelationWithListsOfNumbers;

void main() {
  test('Correlation must be computed correctly with List<double>', () {
    List<double> listOfNumbers1 = [2.2, 1.0];
    List<double> listOfNumbers2 = [3.5, -1.7];

    double correlationCoefficient = computePearsonCorrelationWithListsOfNumbers(
        listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient, 1.0);

    listOfNumbers1 = [14.2, -16.4, 11.9, 15.2];
    listOfNumbers2 = [2.1, 32.5, -1.8, 3.3];

    correlationCoefficient = computePearsonCorrelationWithListsOfNumbers(
        listOfNumbers1, listOfNumbers2);
    expect(correlationCoefficient.toStringAsFixed(4), '-0.9738');
  });

  test('Correlation must be computed correctly with List<double>', () {
    List<double> listOfNumbers1 = [2, -1];
    List<double> listOfNumbers2 = [-4, 5];

    double correlationCoefficient = computePearsonCorrelationWithListsOfNumbers(
        listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient, -1.0);

    listOfNumbers1 = [0, 6, 1];
    listOfNumbers2 = [10, -2, 12];

    correlationCoefficient = computePearsonCorrelationWithListsOfNumbers(
        listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient.toStringAsFixed(5), '-0.95863');
  });

  test(
      'Correlation coefficient should be nan if if only one number pair is given',
      () {
    List<double> listOfInts1 = [2];
    List<double> listOfInts2 = [-4];

    double correlationCoefficient =
        computePearsonCorrelationWithListsOfNumbers(listOfInts1, listOfInts2);

    expect(correlationCoefficient.isNaN, true);

    List<double> listOfNumbers1 = [2.3];
    List<double> listOfNumbers2 = [3.5];

    correlationCoefficient = computePearsonCorrelationWithListsOfNumbers(
        listOfNumbers1, listOfNumbers2);

    expect(correlationCoefficient.isNaN, true);
  });

  test('Should throw error if input lists are not of the same length', () {
    List<double> listOfInts1 = [2, 4];
    List<double> listOfInts2 = [-4];

    expect(
        () => computePearsonCorrelationWithListsOfNumbers(
            listOfInts1, listOfInts2),
        throwsArgumentError);
  });

  test('Should throw error if at least one of the input lists is empty', () {
    List<double> listOfInts1 = [];
    List<double> listOfInts2 = [-4];

    expect(
        () => computePearsonCorrelationWithListsOfNumbers(
            listOfInts1, listOfInts2),
        throwsArgumentError);

    listOfInts1 = [3, 4];
    listOfInts2 = [];

    expect(
        () => computePearsonCorrelationWithListsOfNumbers(
            listOfInts1, listOfInts2),
        throwsArgumentError);

    listOfInts1 = [];
    listOfInts2 = [];

    expect(
        () => computePearsonCorrelationWithListsOfNumbers(
            listOfInts1, listOfInts2),
        throwsArgumentError);
  });
}
