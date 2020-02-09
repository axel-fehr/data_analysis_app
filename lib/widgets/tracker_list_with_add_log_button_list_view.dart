import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';

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

void addLog() {
  // TODO: put this function somewhere where it's easier to access for reuse
  print("addLogButton pressed");
  // TODO: add functionality to add a Log (e.g. with an AlertDialog)
}

class TrackerWithAddLogButton extends StatelessWidget {
  final _tracker;
  final buttonSize = 35.0;
  var _addLogButton;

  TrackerWithAddLogButton(this._tracker)
      : _addLogButton = FloatingActionButton(
          onPressed: addLog,
          child: Text('+'),
        );

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(child: _tracker),
      Container(
        height: buttonSize,
        width: buttonSize,
        child: FittedBox(
          child: _addLogButton,
        ),
      ),
    ]);
  }
}
