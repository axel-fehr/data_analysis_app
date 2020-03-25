import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';
import '../widgets/tracker_list_with_add_log_button_list_view.dart';

class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}

class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trackers"),
      ),
      body: Center(child: ScreenCenter()),
      floatingActionButton: AddVariableToTrackButton(),
    );
  }
}

class ScreenCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Visibility(
            child: Text(
              'You haven\'t created a tracker yet.'
              '\nGo ahead and create one!',
              style: TextStyle(fontSize: 16),
            ),
            visible: Provider.of<TrackerList>(context).trackers.isEmpty,
          ),
          Visibility(
            child: Container(
              child: TrackerListWithAddLogButtonListView(),
              width: double.infinity,
              height: 300,
            ),
            visible: Provider.of<TrackerList>(context).trackers.isNotEmpty,
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
        });
      },
    );
  }
}
