import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/log.dart';

class TrackerLogsAnalysisRoute extends StatelessWidget {
  final String _trackerName;

  TrackerLogsAnalysisRoute(this._trackerName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis'),
      ),
      body: Center(
        child: LogList(_trackerName),
      ),
    );
  }
}

class LogList extends StatelessWidget {
  final String _trackerName;

  LogList(this._trackerName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text('Logs:'),
          Container(
            child: LogListView(_trackerName),
            height: 500,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class LogListView extends StatelessWidget {
  final String _trackerName;

  LogListView(this._trackerName);

  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;

    Tracker matchingTracker = listOfTrackers.singleWhere(
        (tracker) => tracker.name == _trackerName,
        orElse: () => throw ('Provided tracker name not found in list.'));

    List<Padding> logValueList = [];

    matchingTracker.logs.forEach((log) => logValueList.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(log.value.toString()),
        )));

    return ListView(
      children: logValueList,
    );
  }
}
