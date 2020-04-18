import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../providers/tracker_list.dart';
import '../../../classes/tracker.dart';
import '../../../statistics_utils/correlation.dart';

class BinaryTrackerCorrelations extends StatelessWidget {
  final String trackerName; // TODO: more descriptive and less ambiguous name

  BinaryTrackerCorrelations({
    @required this.trackerName,
  });

  /// Returns a map containing the correlation coefficients between the logs
  /// of the tracker with the given tracker name and the logs of the other
  /// trackers, descendingly ordered by magnitude.
  ///
  /// Output:
  /// A map with two entries:
  /// 1. a list of tracker names as Strings,
  /// 2. a list of correlation coefficients as doubles that were computed with
  /// the trackers given in the list of tracker names (same order). This list
  /// is ordered by magnitude in descending order.
  Map<String, List> getCorrelationsWithOtherTrackersOrderedByMagnitude(
      BuildContext context) {
    TrackerList listOfTrackers = Provider.of<TrackerList>(context);
    listOfTrackers.trackers
        .forEach((tracker) => checkIfMultipleLogsOnSameDay(tracker));
    List<Tracker> trackerListCopy = List<Tracker>.from(listOfTrackers.trackers);
    Tracker trackerCorrespondingToLogs =
        trackerListCopy.singleWhere((tracker) => tracker.name == trackerName);

    // avoids computing the correlation with the tracker itself
    trackerListCopy.remove(trackerCorrespondingToLogs);

    List<double> correlationsWithOtherTrackers = [];
    List<String> namesOfOtherTrackers = [];
    trackerListCopy.forEach((otherTracker) {
      if (trackerLogsOverlap(trackerCorrespondingToLogs, otherTracker)) {
        double correlation = computeCorrelationBetweenTwoTrackers(
            trackerCorrespondingToLogs, otherTracker);
        correlationsWithOtherTrackers.add(correlation);
        namesOfOtherTrackers.add(otherTracker.name);
      }
    });

    Map<String, List> sortedCorrelationsAndTrackerNames =
        sortCorrelationsByMagnitudeAndSortTrackerNamesAccordingly(
            correlationsWithOtherTrackers, namesOfOtherTrackers);

    return sortedCorrelationsAndTrackerNames;
  }

  /// Returns a Boolean value indicating whether there is at least one log in
  /// one tracker that was added on the same day as a log in the other tracker.
  bool trackerLogsOverlap(Tracker tracker1, Tracker tracker2) {
    if (tracker1.logs.isEmpty || tracker2.logs.isEmpty) {
      return false;
    }

    for (int tracker1LogIdx = 0;
        tracker1LogIdx < tracker1.logs.length;
        tracker1LogIdx++) {
      for (int tracker2LogIdx = 0;
          tracker2LogIdx < tracker2.logs.length;
          tracker2LogIdx++) {
        DateTime tracker1LogDate =
            convertTimeStampToDate(tracker1.logs[tracker1LogIdx].timeStamp);
        DateTime tracker2LogDate =
            convertTimeStampToDate(tracker2.logs[tracker2LogIdx].timeStamp);
        if (tracker1LogDate == tracker2LogDate) {
          return true;
        }
      }
    }
    return false;
  }

  /// Throws an exception if there logs of the given tracker that were added
  /// on the same day (only one log is allowed per day).
  void checkIfMultipleLogsOnSameDay(Tracker tracker) {
    List<DateTime> datesOfTimeStamps = [];
    tracker.logs.forEach(
        (log) => datesOfTimeStamps.add(convertTimeStampToDate(log.timeStamp)));
    bool notAllDatesUnique =
        datesOfTimeStamps.toSet().length != tracker.logs.length;
    if (notAllDatesUnique) {
      throw ('Found a tracker whose logs are not all from different dates.');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;
    Tracker trackerCorrespondingToLogs =
        listOfTrackers.singleWhere((tracker) => tracker.name == trackerName);

    if (trackerCorrespondingToLogs.logs.isNotEmpty) {
      Map sortedTrackerNamesAndCorrelations =
          getCorrelationsWithOtherTrackersOrderedByMagnitude(context);
      List<double> sortedCorrelations =
          sortedTrackerNamesAndCorrelations['correlations'];
      List<String> trackerNames =
          sortedTrackerNamesAndCorrelations['trackerNames'];

      if (sortedCorrelations.length != trackerNames.length) {
        throw ('Number of correlations and number of returned tracker names is'
            'not equal.');
      }

      // TODO: make this all look pretty!
      if (sortedCorrelations.isEmpty) {
        return Text(
            'No correlations to display.'); // TODO: add an explanation here and what is needed to display correlations
      } else {
        // TODO: use list of list tiles here where each list tile contains the tracker name and the correlation
        return Container(
          child: ListView(
            children: List<Widget>.generate(sortedCorrelations.length,
                (index) => Text(sortedCorrelations[index].toString())),
          ),
          height: 100,
          width: double.infinity,
        );
        // TODO: would be nice to display how many values the correlation was computed with
        // TODO: is it possible to give some kind of 'confidence' about the correlation based on the number of samples? If yes, do that
      }
    } else {
      return Text('Correlations cannot be computed because this tracker does '
          'not have any logs. Add logs and the app will display '
          'correlations for you here');
    }
  }
}
