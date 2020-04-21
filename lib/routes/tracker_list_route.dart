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
      body: Content(),
      floatingActionButton: AddTrackerButton(),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<TrackerList>(context).trackers.isEmpty) {
      return Center(
        child: Text(
          'You haven\'t created a tracker yet.'
          '\nGo ahead and create one!',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Container(
        child: TrackerListWithAddLogButtonListView(),
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}

class AddTrackerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Text(
        '+',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
      ),
      onPressed: () {
        showAlertDialogToAddTracker(context).then((onValue) {
          if (onValue != null && onValue != '') {
            final trackerListObject = Provider.of<TrackerList>(context);
            trackerListObject.addTracker(onValue);
          }
        });
      },
    );
  }

  Future<String> showAlertDialogToAddTracker(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AddTrackerAlertDialog();
        });
  }
}

class AddTrackerAlertDialog extends StatefulWidget {
  @override
  _AddTrackerAlertDialogState createState() => _AddTrackerAlertDialogState();
}

class _AddTrackerAlertDialogState extends State<AddTrackerAlertDialog> {
  TextEditingController customController = TextEditingController();

  // determines whether a warning is shown that tells the user that he must
  // not add a tracker with a name that already exists
  bool showTrackerNameWarning = false;

  @override
  Widget build(BuildContext context) {
    List<String> trackerNames = Provider.of<TrackerList>(context).trackerNames;

    return AlertDialog(
      title: Text('Tracker name'),
      content: Container(
        child: Column(
          children: <Widget>[
            TextField(
              controller: customController,
              onChanged: (String enteredText) {
                if (trackerNames.contains(customController.text.toString())) {
                  setState(() {
                    showTrackerNameWarning = true;
                  });
                }
                // removes the warning if entered text is not an existing name
                else if (showTrackerNameWarning = true) {
                  setState(() {
                    showTrackerNameWarning = false;
                  });
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Visibility(
                child: Text(
                  'Name already exists!',
                  style: TextStyle(color: Colors.redAccent),
                ),
                visible: showTrackerNameWarning,
              ),
            ),
          ],
        ),
        height: 90,
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('Add'),
          onPressed: () {
            String enteredTrackerName = customController.text.toString();
            // if the tracker name does not already exist, add the tracker
            if (!trackerNames.contains(enteredTrackerName)) {
              Navigator.of(context).pop(enteredTrackerName);
            }
          },
        )
      ],
    );
  }
}
