import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/show_list_of_trackers.dart';
import '../providers/tracker_list.dart';
import '../widgets/tracker_list_view.dart';

class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}

class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (showTrackerListContext) => ShowListOfTrackers(show: false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Trackers"),
        ),
        body: Center(child: ScreenCenter()),
        floatingActionButton: AddVariableToTrackButton(),
      ),
    );
  }
}

class ScreenCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showListObject = Provider.of<ShowListOfTrackers>(context);
    final showList = showListObject.show;
    return Center(
      child: Column(
        children: <Widget>[
          Visibility(
            child: Text(
              'You haven\'t created a tracker yet.'
              '\nGo ahead and create one!',
              style: TextStyle(fontSize: 16),
            ),
            visible: !showList,
          ),
          Visibility(
            child: Container(
              child: TrackerListView(), //variablesList,
              width: 200,
              height: 200,
            ),
            visible: showList,
          )
        ],
      ),
    );
  }
}

class AddVariableToTrackButton extends StatelessWidget {
  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Tracker name'),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text('Add'),
                onPressed: () {
                  Navigator.of(context).pop(customController.text.toString());
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Text(
        '+',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
      ),
      onPressed: () {
        createAlertDialog(context).then((onValue) {
          SnackBar mySnackBar = SnackBar(
              content: Text(
            "Hello $onValue",
          ));
          Scaffold.of(context).showSnackBar(mySnackBar);

          final trackerListObject = Provider.of<TrackerList>(context);
          trackerListObject.addTracker(onValue);

          final showListObject = Provider.of<ShowListOfTrackers>(context);
          showListObject.setShow(true);
        });
      },
    );
  }
}
