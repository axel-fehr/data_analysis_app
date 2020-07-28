import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../utils/statistics_utils/correlation.dart';
import '../../utils/general.dart';

class TrackerCorrelations extends StatelessWidget {
  final String nameOfTrackerBeingAnalyzed;

  TrackerCorrelations({
    @required this.nameOfTrackerBeingAnalyzed,
  });

  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;

    if (listOfTrackers.length == 1) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Cannot be computed because no other trackers exist.'),
      );
    } else {
      Tracker trackerBeingAnalyzed = listOfTrackers
          .singleWhere((tracker) => tracker.name == nameOfTrackerBeingAnalyzed);

      if (trackerBeingAnalyzed.logs.isNotEmpty) {
        return Expanded(
          child: ListOfCorrelationsWithOtherTrackers(
            nameOfTrackerBeingAnalyzed: nameOfTrackerBeingAnalyzed,
          ),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Correlations with other trackers will be displayed '
              'for you here when you have added enough logs.'),
        );
      }
    }
  }
}

class ListOfCorrelationsWithOtherTrackers extends StatelessWidget {
  final String nameOfTrackerBeingAnalyzed;

  ListOfCorrelationsWithOtherTrackers({this.nameOfTrackerBeingAnalyzed});

  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;

    Map sortedTrackerNamesAndCorrelations =
        getCorrelationsWithOtherTrackersOrderedByMagnitude(context);
    List<double> sortedCorrelations =
        sortedTrackerNamesAndCorrelations['correlations'];
    List<String> sortedTrackerNames =
        sortedTrackerNamesAndCorrelations['trackerNames'];

    if (sortedCorrelations.length != sortedTrackerNames.length) {
      throw ('Number of correlations and number of returned tracker names are'
          'not equal.');
    }

    List<Widget> correlationTableRows = [];

    for (int i = 0; i < sortedCorrelations.length; i++) {
      if (sortedCorrelations[i].isNaN) {
        correlationTableRows.add(TrackerCorrelationListTile(
          sortedTrackerNames[i],
          moreDataNeeded: true,
        ));
      } else {
        correlationTableRows.add(TrackerCorrelationListTile(
          sortedTrackerNames[i],
          correlation: sortedCorrelations[i],
        ));
      }
    }

    bool trackersWithNoCorrelationValuesExist;
    trackersWithNoCorrelationValuesExist =
        listOfTrackers.length - 1 != sortedCorrelations.length;
    if (trackersWithNoCorrelationValuesExist) {
      for (int i = 0; i < listOfTrackers.length; i++) {
        if (!sortedTrackerNames.contains(listOfTrackers[i].name) &&
            listOfTrackers[i].name != nameOfTrackerBeingAnalyzed) {
          correlationTableRows.add(TrackerCorrelationListTile(
            listOfTrackers[i].name,
            moreDataNeeded: true,
          ));
        }
      }
    }

    return Container(
      child: ListView(
        children: correlationTableRows,
      ),
    );
    // TODO: display how many values the correlation was computed with
    // TODO: display a measure for the confidence or uncertainty of the result
  }

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
    Tracker trackerCorrespondingToLogs = trackerListCopy
        .singleWhere((tracker) => tracker.name == nameOfTrackerBeingAnalyzed);

    // avoids computing the correlation with the tracker itself
    trackerListCopy.remove(trackerCorrespondingToLogs);

    List<double> correlationsWithOtherTrackers = [];
    List<String> namesOfOtherTrackers = [];
    trackerListCopy.forEach((otherTracker) {
      if (trackerLogsOverlap(trackerCorrespondingToLogs, otherTracker)) {
        double correlation;

        if (trackerCorrespondingToLogs.logType == bool ||
            otherTracker.logType == bool) {
          // compute the pearson correlation coefficient, which is the same
          // as the phi coefficient when computed with two binary trackers and
          // the point-biserial coefficient when computed with a binary and a
          // numerical tracker (assuming binary values are 0s and 1s)
          correlation = computePearsonCorrelationBetweenTwoTrackers(
              trackerCorrespondingToLogs, otherTracker);
        } else {
          correlation = computeSpearmanCorrelationBetweenTwoTrackers(
              trackerCorrespondingToLogs, otherTracker);
        }

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
}

class TrackerCorrelationListTile extends StatelessWidget {
  final String trackerName;
  final double correlation;
  final bool moreDataNeeded;

  TrackerCorrelationListTile(this.trackerName,
      {this.correlation = double.nan, this.moreDataNeeded = false});

  @override
  Widget build(BuildContext context) {
    String displayedCorrelationValue;
    if (moreDataNeeded || correlation.isNaN) {
      displayedCorrelationValue = 'More data needed';
    } else {
      displayedCorrelationValue = correlation.toStringAsFixed(2);
    }
    String trackerNameWithCorrelation =
        trackerName + ': ' + displayedCorrelationValue;

    return ListTile(
      title: Row(
        children: <Widget>[
          // needed to make text wrap in case of long tracker names
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(trackerNameWithCorrelation)],
            ),
          )
        ],
      ),
    );
  }
}
