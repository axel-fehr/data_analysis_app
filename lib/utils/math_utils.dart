import 'package:flutter/cupertino.dart';

/// Contains implementations of commonly used mathematical functions

/// Returns the sum of all elements in the given list of numbers.
double sum(List<double> numbers) {
  return numbers.reduce((value, element) => value + element);
}

/// Returns the mean of all elements in the given list of numbers.
double mean(List<double> numbers) {
  return sum(numbers) / numbers.length;
}

/// Returns the median of all elements in the given list of numbers.
double median(List<double> numbers) {
  if (numbers.isEmpty || numbers.length == 1) {
    throw ArgumentError('The input list of numbers must not be empty.');
  }

  numbers.sort();
  if (numbers.length.isOdd) {
    int indexOfMedian = (numbers.length / 2).floor();
    return numbers[indexOfMedian];
  } else {
    int halfLength = numbers.length ~/ 2;
    double middleValue1 = numbers[halfLength - 1];
    double middleValue2 = numbers[halfLength];
    return mean([middleValue1, middleValue2]);
  }
}

/// Returns a ordered list containing the elements that occur most often in the
/// given list of numbers.
///
/// The returned list contains multiple elements if there are multiple elements
/// where the number of occurrences is equal to the maximum number of
/// occurrences of any element.
List<int> mode(List<int> numbers) {
  if (numbers.isEmpty) {
    throw ArgumentError('Input list must not be empty.');
  }

  Map<int, int> numberCounts = <int, int>{};
  numbers.forEach((element) {
    if (!numberCounts.containsKey(element)) {
      numberCounts[element] = 1;
    } else {
      numberCounts[element] += 1;
    }
  });

  int highestCount = 0;
  numberCounts.forEach((number, numOccurrences) {
    if (numOccurrences > highestCount) {
      highestCount = numOccurrences;
    }
  });

  // return an empty list when all numbers in the list are unique since
  // there is no mode in this case
  if (highestCount == 1) {
    return <int>[];
  }

  List<int> mostFrequentlyOccurringNumbers = <int>[];
  numberCounts.forEach((number, numOccurrences) {
    if (numberCounts[number] == highestCount) {
      mostFrequentlyOccurringNumbers.add(number);
    }
  });

  mostFrequentlyOccurringNumbers.sort();

  return mostFrequentlyOccurringNumbers;
}
