import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';
import '../classes/tracker.dart';

class TrackerListWithAddLogButtonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var listOfTrackers = Provider.of<TrackerList>(context).trackers;

    var trackerWithAddLogButtonList = List<TrackerWithAddLogButton>();

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
//  final _addLogButton;

  showLogAlertDialog(BuildContext context) {
    // set up the buttons
    Widget trueButton = FlatButton(
      child: Text("False"),
      onPressed: () {
        _tracker.addLog(false);
        Navigator.of(context).pop();
      },
    );

    Widget falseButton = FlatButton(
      child: Text("True"),
      onPressed: () {
        _tracker.addLog(true);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Log"),
      content: Text("Please enter the log value."),
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

//  TODO: WATCH THIS: https://www.youtube.com/watch?v=75CsnyRXf5I

  TrackerWithAddLogButton(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(child: Container(child: Text(_tracker.name))),
      Container(
          height: buttonSize,
          width: buttonSize,
          child: FittedBox(
            child: FloatingActionButton(
                onPressed: () => showLogAlertDialog(context),
                child: Text('+') //_addLogButton
                ),
          )),
    ]);
  }
}
