import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../routes/tracker_logs_analysis_route.dart';
import '../utils/rename_tracker_utils.dart' as rename_tracker_utils;
import './buttons/add_log_button.dart' show AddLogButton;

class TrackerListWithAddLogButtonListView extends StatefulWidget {
  @override
  _TrackerListWithAddLogButtonListViewState createState() =>
      _TrackerListWithAddLogButtonListViewState();
}

class _TrackerListWithAddLogButtonListViewState
    extends State<TrackerListWithAddLogButtonListView> {
  @override
  Widget build(BuildContext context) {
    List<Tracker> listOfTrackers = Provider.of<TrackerList>(context).trackers;
    List<TrackerWithAddLogButton> trackerWithAddLogButtonList = [];
    listOfTrackers.forEach(
      (tracker) => trackerWithAddLogButtonList.add(
        TrackerWithAddLogButton(
          tracker: tracker,
          key: UniqueKey(),
        ),
      ),
    );

    TrackerList trackerList = Provider.of<TrackerList>(context);
    return ReorderableListView(
      children: trackerWithAddLogButtonList,
      onReorder: (int oldIndex, int newIndex) {
        trackerList.changePositionOfTracker(
            indexOfTracker: oldIndex, desiredIndexOfTracker: newIndex);
      },
    );
  }
}

class TrackerWithAddLogButton extends StatelessWidget {
  final Tracker _tracker;

  Tracker get tracker => _tracker;

  const TrackerWithAddLogButton({
    Key key,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: TappableTrackerName(tracker: _tracker),
          trailing: AddLogButton(tracker: _tracker),
        ),
      ),
      actions: <Widget>[], // shown when user swipes to the right
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () =>
              letUserConfirmTrackerDeletion(context, trackerToDelete: _tracker),
        ),
        IconSlideAction(
          caption: 'Rename',
          color: Colors.green,
          icon: Icons.edit,
          onTap: () =>
              rename_tracker_utils.letUserRenameTracker(context, _tracker.name),
        ),
      ],
    );
  }

  void letUserConfirmTrackerDeletion(BuildContext context,
      {@required Tracker trackerToDelete}) {
    Widget noButton = FlatButton(
      child: const Text('No'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget yesButton = FlatButton(
      child: const Text('Yes'),
      onPressed: () {
        Provider.of<TrackerList>(context).deleteTracker(_tracker);
        Navigator.of(context).pop();
      },
    );

    CupertinoAlertDialog confirmDeletionAlertDialog = CupertinoAlertDialog(
      title: const Text('Are you sure?'),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return confirmDeletionAlertDialog;
      },
    );
  }
}

class TappableTrackerName extends StatelessWidget {
  final Tracker _tracker;

  const TappableTrackerName({
    Key key,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

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
