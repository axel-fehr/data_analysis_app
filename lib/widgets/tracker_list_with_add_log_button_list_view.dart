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
        (tracker) => trackerWithAddLogButtonList.add(TrackerWithAddLogButton(tracker)));

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
          onTap: () =>
              Provider.of<TrackerList>(context).removeTracker(_tracker),
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

/// A button that can be used to add logs.
///
/// How it is displayed and what it does when pressed depends on whether there
/// already is a log that was logged on the same day for that tracker or not.
/// If there is, it will not be possible to add another log. This is done to
/// ensure that there cannot be multiple logs from the same day for the same
/// tracker. If there is not, a log can be added.
class AddLogButton extends StatefulWidget {
  final double buttonSize;
  final Tracker _tracker;

  const AddLogButton({
    Key key,
    @required this.buttonSize,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  @override
  _AddLogButtonState createState() => _AddLogButtonState();
}

class _AddLogButtonState extends State<AddLogButton> {
  void showAddLogAlertDialog(BuildContext context) {
    Widget falseButton = FlatButton(
      child: Text('False'),
      onPressed: () {
        widget._tracker.addLog(false);
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
        setState(() {});
      },
    );

    Widget trueButton = FlatButton(
      child: Text('True'),
      onPressed: () {
        widget._tracker.addLog(true);
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
        setState(() {});
      },
    );

    CupertinoAlertDialog addLogAlertDialog = CupertinoAlertDialog(
      title: Text('Log'),
      content: Text('Please enter the log value.'),
      actions: [
        falseButton,
        trueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return addLogAlertDialog;
      },
    );
  }

  void showExplanationForDisabledButton(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        'You can only add one log per day. '
        'You can modify the log you added today by '
        'tapping on the tracker name.',
        style: TextStyle(fontSize: 18.0),
      ),
      duration: Duration(seconds: 6),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastLogTimeStamp = widget._tracker.logs.last.timeStamp;
    DateTime now = DateTime.now();
    bool logFromSameDayExists = ((lastLogTimeStamp.year == now.year) &
        (lastLogTimeStamp.month == now.month) &
        (lastLogTimeStamp.day == now.day));

    return Container(
        height: widget.buttonSize,
        width: widget.buttonSize,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => logFromSameDayExists
                ? showExplanationForDisabledButton(context)
                : showAddLogAlertDialog(context),
            child: Text(
              '+',
              style: TextStyle(fontSize: 32),
            ),
            heroTag: widget._tracker.name + '_addLogButton',
            backgroundColor: logFromSameDayExists
                ? Colors.blue[50]
                : ThemeData().accentColor,
          ),
        ));
  }
}
