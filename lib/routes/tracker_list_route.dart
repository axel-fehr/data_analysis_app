import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/tracker_list.dart';
import '../widgets/tracker_list_with_add_log_button_list_view.dart';
import '../widgets/disclaimer_or_warning.dart';

class TrackerListRoute extends StatefulWidget {
  @override
  _TrackerListRouteState createState() => _TrackerListRouteState();
}

class _TrackerListRouteState extends State<TrackerListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackers'),
      ),
      body: Content(),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<TrackerList>(context).trackers.isEmpty) {
      return NoTrackerPage();
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: TrackerListWithAddLogButtonListView(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DisclaimerOrWarning(
                    text:
                        'The information provided on this app is not medical advice.',
                  ),
                ),
                Align(
                  child: AddTrackerButton(),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

/// The page that is shown when the user hasn't created a tracker yet.
class NoTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: const Center(
            child: Text(
              'You haven\'t created a tracker yet.'
              '\nGo ahead and create one!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddTrackerButton(),
          ),
        ),
      ],
    );
  }
}

class AddTrackerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Text(
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

  final Text _trackerNameWarning = const Text(
    'Name already exists!',
    style: TextStyle(color: Colors.redAccent),
  );

  // A hint that tells the user what kind of tracker to enter, to make it
  // clear that it has to be something answerable with yes or no.
  final Text _inputHint = const Text(
    "Must be answerable with 'yes' or 'no'",
    style: TextStyle(color: Colors.black45),
  );

  @override
  Widget build(BuildContext context) {
    List<String> trackerNames = Provider.of<TrackerList>(context).trackerNames;

    return AlertDialog(
      title: const Text('What do you want to track?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: customController,
              maxLength: 50,
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
              padding: const EdgeInsets.only(top: 8.0),
              child: showTrackerNameWarning ? _trackerNameWarning : _inputHint,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: const Text(
            'Add',
            style: TextStyle(color: Colors.blueAccent),
          ),
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
