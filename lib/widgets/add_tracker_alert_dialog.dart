import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/enumerations/user_interaction.dart';

import '../providers/tracker_list.dart';
import '../classes/user_interaction_database.dart';
import '../widgets/bulleted_list.dart';

class AddTrackerAlertDialog extends StatefulWidget {
  @override
  _AddTrackerAlertDialogState createState() => _AddTrackerAlertDialogState();
}

class _AddTrackerAlertDialogState extends State<AddTrackerAlertDialog> {
  // shown when a tracker with the entered name already exists
  static const Text _trackerNameWarning = Text(
    'Name already exists!',
    style: TextStyle(color: Colors.redAccent),
  );

  // A hint that tells the user what kind of tracker to enter, to make it
  // clear that it has to be something answerable with yes or no.
  static const Text _inputHint = Text(
    "Must be answerable with 'yes' or 'no'",
    style: TextStyle(color: Colors.black45),
  );

  final TextEditingController _customController = TextEditingController();

  // determines whether a warning is shown that tells the user that he must
  // not add a tracker with a name that already exists
  bool showTrackerNameWarning = false;

  @override
  Widget build(BuildContext context) {
    List<String> trackerNames = Provider.of<TrackerList>(context).trackerNames;

    TextField enterTrackerNameTextField = TextField(
      controller: _customController,
      maxLength: 50,
      onChanged: (String enteredText) {
        if (trackerNames.contains(_customController.text.toString())) {
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
    );

    return AlertDialog(
      title: const Text('What do you want to track?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            enterTrackerNameTextField,
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
            String enteredTrackerName = _customController.text.toString();
            // if the tracker name does not already exist, add the tracker
            if (!trackerNames.contains(enteredTrackerName)) {
              bool userCreatedHisFirstTracker = false;
              UserInteractionDatabase userInteractionDatabase =
                  Provider.of<UserInteractionDatabase>(context);
              if (!userInteractionDatabase
                  .isRecorded(UserInteraction.createdTracker)) {
                userCreatedHisFirstTracker = true;
                userInteractionDatabase
                    .recordUserInteraction(UserInteraction.createdTracker);
              }
              Navigator.of(context).pop(enteredTrackerName);

              if (userCreatedHisFirstTracker) {
                showAppExplanation(context);
              }
            }
          },
        ),
      ],
    );
  }

  /// Shows an alert dialog to the user that explains the basics of the app.
  Future<void> showAppExplanation(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return ExplainAppBasicsAlertDialog();
      },
      // Disables the dismissal of the alert dialog by tapping the area outside
      // it. This prevents the user from accidentally dismissing it before
      // having read everything.
      barrierDismissible: false,
    );
  }
}

/// An alert dialog that explains the basics of the app to the user so that he
/// knows how to use the app.
class ExplainAppBasicsAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Things you should know'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BulletedList([
              'You can add one log per day per tracker',
              'Tap on a tracker in the list to see more detailed statistics',
              "These statistics aren't very insightful at the beginning since "
                  'there is not a lot of data yet. But the more logs you add '
                  'over time, the more insightful these statistics will become!'
            ]),
            Align(
              child: FlatButton(
                child: Text(
                  'Got it',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}
