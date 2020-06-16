import 'package:test/test.dart';

import 'package:tracking_app/classes/log.dart';
import 'package:tracking_app/utils/statistics_utils/correlation.dart'
    show getIndicesOfLogsAddedOnTheSameDay;

void main() {
  test(
      'Indices must be correct with tracker with trackers with '
      'different amounts of logs', () {
    // Test 1
    List<Log> listOfLogs1 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 15)),
      Log<bool>(false, timeStamp: DateTime(2020, 4, 16))
    ];
    List<Log> listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 15)),
    ];

    List<List<int>> indicesList =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    List<List<int>> indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    List<List<int>> expectedResult = [
      [0],
      [0]
    ];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult.reversed.toList());

    // Test 2
    listOfLogs1 = [
      Log<bool>(true, timeStamp: DateTime(2020, 3, 5)),
      Log<bool>(false, timeStamp: DateTime(2020, 3, 7)),
      Log<bool>(false, timeStamp: DateTime(2020, 3, 9)),
    ];
    listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2020, 3, 7)),
      Log<bool>(true, timeStamp: DateTime(2020, 3, 8)),
      Log<bool>(true, timeStamp: DateTime(2020, 3, 9)),
    ];

    indicesList = getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    expectedResult = [
      [1, 2],
      [0, 2]
    ];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult.reversed.toList());

    // Test 3
    listOfLogs1 = [
      Log<bool>(true, timeStamp: DateTime(2020, 5, 20)),
      Log<bool>(false, timeStamp: DateTime(2020, 5, 21)),
      Log<bool>(false, timeStamp: DateTime(2020, 5, 22)),
    ];
    listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 20)),
      Log<bool>(false, timeStamp: DateTime(2020, 5, 21)),
      Log<bool>(false, timeStamp: DateTime(2021, 5, 22)),
    ];

    indicesList = getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    expectedResult = [
      [1],
      [1]
    ];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult.reversed.toList());
  });

  test('Lists in lists of indices must be empty when there is no overlap', () {
    // Test 1
    List<Log> listOfLogs1 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 15)),
      Log<bool>(false, timeStamp: DateTime(2020, 4, 16))
    ];
    List<Log> listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 17)),
    ];

    List<List<int>> indicesList =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    List<List<int>> indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    List<List<int>> expectedResult = [[], []];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult);

    // Test 2
    listOfLogs1 = [
      Log<bool>(true, timeStamp: DateTime(2020, 3, 5)),
      Log<bool>(false, timeStamp: DateTime(2020, 3, 6)),
      Log<bool>(false, timeStamp: DateTime(2020, 3, 7)),
    ];
    listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2019, 3, 5)),
      Log<bool>(true, timeStamp: DateTime(2020, 4, 6)),
      Log<bool>(true, timeStamp: DateTime(2020, 4, 7)),
    ];

    indicesList = getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    expectedResult = [[], []];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult.reversed.toList());
  });

  test('Lists in lists of indices must be empty when one input list is empty',
      () {
    List<Log> listOfLogs1 = [];
    List<Log> listOfLogs2 = [
      Log<bool>(true, timeStamp: DateTime(2020, 4, 17)),
    ];

    List<List<int>> indicesList =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    List<List<int>> indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    List<List<int>> expectedResult = [[], []];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult);
  });

  test('Lists in lists of indices must be empty when both input list are empty',
      () {
    List<Log> listOfLogs1 = [];
    List<Log> listOfLogs2 = [];

    List<List<int>> indicesList =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs1, listOfLogs2);
    List<List<int>> indicesListWithSwappedArguments =
        getIndicesOfLogsAddedOnTheSameDay(listOfLogs2, listOfLogs1);

    List<List<int>> expectedResult = [[], []];
    expect(indicesList, expectedResult);
    expect(indicesListWithSwappedArguments, expectedResult);
  });
}
