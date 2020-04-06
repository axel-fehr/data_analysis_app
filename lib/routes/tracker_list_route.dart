import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';
import '../widgets/tracker_list_with_add_log_button_list_view.dart';

class TrackerListRoute extends StatefulWidget {
  @override
  _TrackerListRouteState createState() => _TrackerListRouteState();
}

class _TrackerListRouteState extends State<TrackerListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trackers'),
      ),
      body: Center(child: ScreenCenter()),
      floatingActionButton: AddTrackerButton(),
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
            child: Text( // TODO: put this in the center of the screen and make it bigger
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

class AddTrackerButton extends StatelessWidget {
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
            'Hello $onValue', // TODO: snackbar is unnecessary, since the appearing tracker already provides feedback. don't show the snackbar. makes the code simpler as well.
          ));
          Scaffold.of(context).showSnackBar(mySnackBar); // TODO: see above

          final trackerListObject = Provider.of<TrackerList>(context);
          trackerListObject.addTracker(onValue);
        });
      },
    );
  }
}
