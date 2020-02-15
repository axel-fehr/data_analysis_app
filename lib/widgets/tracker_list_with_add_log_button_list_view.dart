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
  final _addLogButton;

//  void createAddLogAlertDialog() {
//    TextEditingController customController = TextEditingController();
//
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('Tracker name'),
//            content: TextField(
//              controller: customController,
//            ),
//            actions: <Widget>[
//              MaterialButton(
//                elevation: 5.0,
//                child: Text('Add'),
//                onPressed: () {
//                  Navigator.of(context).pop(customController.text.toString());
//                },
//              )
//            ],
//          );
//        });
//  }

  TrackerWithAddLogButton(this._tracker)
      : _addLogButton = FloatingActionButton(
          onPressed: () => _tracker.addLog(
              true), // TESTING TODO: ADD A FUNCTION HERE THAT CREATES AN ALERT DIALOG WHERE THE LOG IS ENTERED
          child: Text('+'),
        );

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(child: Container(child: Text(_tracker.name))),
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
