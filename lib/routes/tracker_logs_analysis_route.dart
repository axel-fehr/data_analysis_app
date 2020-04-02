import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

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
            child: LogListWithEditButtonsListView(_trackerName),
            height: 500,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}

class LogListWithEditButtonsListView extends StatelessWidget {
  final String _trackerName;

  LogListWithEditButtonsListView(this._trackerName);

  /// Returns the tracker that has the name given by the field '_trackerName'.
  Tracker getTrackerWithTrackerName(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;

    Tracker matchingTracker = listOfTrackers.singleWhere(
        (tracker) => tracker.name == _trackerName,
        orElse: () => throw ('Provided tracker name not found in list.'));

    return matchingTracker;
  }

  @override
  Widget build(BuildContext context) {
    Tracker correspondingTracker = getTrackerWithTrackerName(context);
    List<Padding> logValueList = [];

    correspondingTracker.logs.forEach((log) => logValueList.add(Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LogWithEditButton(log),
        )));

    return ListView(
      children: logValueList,
    );
  }
}

class LogWithEditButton extends StatelessWidget {
  final Log _log;

  LogWithEditButton(this._log);
  //TODO: let's have edit / pencil icon next to each item on button press, when pressed, popup dialog opens where log can be deleted or value can be changed
  void showLogEditAlertDialog(BuildContext context) {
    // TODO: change the alert dialog depending on the type of the tracker (create one separate widget for each alert dialog (for each tracker type))
    Widget changeLogButton = FlatButton(
      child: Text('Change to False'),
      onPressed: () {
        print('pressed change'); // TODO: implement change of log value (update DB as well!)
        Navigator.of(context).pop();
      },
    );
    // TODO: consider using a provider for the log and tracker database, needed at a lot of places, use provider here then
    Widget deleteLogButton = FlatButton(
      child: Icon(Icons.delete),
      onPressed: () {
        print('pressed delete'); // TODO: implement deletion of log (update DB as well!)
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Edit Log'),
      actions: [
        changeLogButton,
        deleteLogButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(_log.value.toString())),
        InkWell(
          child: Icon(Icons.create),
          onTap: () => showLogEditAlertDialog(context), // print('edit'),
        ),
      ],
    );
  }
}
