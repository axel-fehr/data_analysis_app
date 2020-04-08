import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
      children: trackerWithAddLogButtonList,
    );
  }
}

class TrackerWithAddLogButton extends StatelessWidget {
  final Tracker _tracker;
  final buttonSize = 35.0;

  TrackerWithAddLogButton(this._tracker);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: TrackerName(tracker: _tracker),
          trailing: AddLogButton(buttonSize: buttonSize, tracker: _tracker),
        ),
      ),
      actions: <Widget>[], // shown when user swipes to the right
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => Provider.of<TrackerList>(context).removeTracker(_tracker),
        ),
      ],
    );
  }
}

class TrackerName extends StatelessWidget {
  const TrackerName({
    Key key,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  final Tracker _tracker;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(_tracker.name),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TrackerLogsAnalysisRoute(_tracker)),
      ),
    );
  }
}

class AddLogButton extends StatelessWidget {
  const AddLogButton({
    Key key,
    @required this.buttonSize,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  final double buttonSize;
  final Tracker _tracker;

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

  @override
  Widget build(BuildContext context) {
    return Container(
        height: buttonSize,
        width: buttonSize,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => showLogAlertDialog(context),
            child: Text(
              '+',
              style: TextStyle(fontSize: 32),
            ),
            heroTag: _tracker.name + '_addLogButton',
          ),
        ));
  }
}
