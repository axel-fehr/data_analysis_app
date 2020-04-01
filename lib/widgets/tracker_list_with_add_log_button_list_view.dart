import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../routes/tracker_logs_analysis_route.dart';

class TrackerListWithAddLogButtonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;
    List<TrackerWithAddLogButton> trackerWithAddLogButtonList = [];

    listOfTrackers.forEach(
        (e) => trackerWithAddLogButtonList.add(TrackerWithAddLogButton(e)));

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: trackerWithAddLogButtonList,
      // TODO: add space between the elements (e.g. with a grey separating line)
    );
  }
}

class TrackerWithAddLogButton extends StatelessWidget {
  final Tracker _tracker;
  final buttonSize = 35.0;

  void showLogAlertDialog(BuildContext context) {
    // set up the buttons
    Widget falseButton = FlatButton(
      child: Text('False'),
      onPressed: () {
        _tracker.addLog(false);
        Navigator.of(context).pop();
      },
    );

    Widget trueButton = FlatButton(
      child: Text('True'),
      onPressed: () {
        _tracker.addLog(true);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text('Log'),
      content: Text('Please enter the log value.'),
      actions: [
        falseButton,
        trueButton,
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

  TrackerWithAddLogButton(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
        child: InkWell(
          child: Container(child: Text(_tracker.name)),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackerLogsAnalysisRoute(_tracker.name)),
          ),
        ),
      ),
      Container(
          height: buttonSize,
          width: buttonSize,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () => showLogAlertDialog(context),
              child: Text('+'),
              heroTag: _tracker.name + '_addLogButton',
            ),
          )),
    ]);
  }
}
