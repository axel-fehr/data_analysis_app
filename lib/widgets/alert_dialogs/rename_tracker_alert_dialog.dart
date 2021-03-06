import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../providers/tracker_list.dart';

class RenameTrackerAlertDialog extends StatefulWidget {
  @override
  _RenameTrackerAlertDialogState createState() =>
      _RenameTrackerAlertDialogState();
}

class _RenameTrackerAlertDialogState extends State<RenameTrackerAlertDialog> {
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

  final TextEditingController customController = TextEditingController();

  // determines whether a warning is shown that tells the user that he must
  // not add a tracker with a name that already exists
  bool showTrackerNameWarning = false;

  @override
  Widget build(BuildContext context) {
    List<String> trackerNames = Provider.of<TrackerList>(context).trackerNames;

    return AlertDialog(
      title: const Text('Enter new name'),
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