import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../classes/tracker.dart';
import '../../utils/general.dart';
import '../alert_dialogs/add_log_alert_dialog.dart' show AddLogAlertDialog;

/// A button that can be used to add logs.
///
/// How it is displayed and what it does when pressed depends on whether there
/// already is a log that was logged on the same day for that tracker or not.
/// If there is, it will not be possible to add another log. This is done to
/// ensure that there cannot be multiple logs from the same day for the same
/// tracker. If there is not, a log can be added.
class AddLogButton extends StatefulWidget {
  final double buttonSize = 35.0;
  final Tracker _tracker;

  const AddLogButton({
    Key key,
    @required Tracker tracker,
  })  : _tracker = tracker,
        super(key: key);

  @override
  _AddLogButtonState createState() => _AddLogButtonState();
}

class _AddLogButtonState extends State<AddLogButton> {
  @override
  Widget build(BuildContext context) {
    bool logFromSameDayExists;
    if (widget._tracker.logs.isNotEmpty) {
      // logs with the most recent time stamp are first (list is ordered)
      DateTime mostRecentLogTimeStamp = widget._tracker.logs.first.timeStamp;
      DateTime currentDate = convertTimeStampToDate(DateTime.now());
      logFromSameDayExists =
          (convertTimeStampToDate(mostRecentLogTimeStamp) == currentDate);
    } else {
      logFromSameDayExists = false;
    }

    return Container(
        height: widget.buttonSize,
        width: widget.buttonSize,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () => logFromSameDayExists
                ? showExplanationForDisabledButton(context)
                : showAddLogAlertDialog(context, widget._tracker, () {
                    // triggers the rebuild of the tracker list route to
                    // deactivate the add log button if a log was added
                    setState(() => {});
                  }),
            child: const Text(
              '+',
              style: TextStyle(fontSize: 32),
            ),
            heroTag: widget._tracker.name + '_addLogButton',
            backgroundColor: logFromSameDayExists
                ? Colors.blue[50]
                : ThemeData().accentColor,
          ),
        ));
  }

  void showAddLogAlertDialog(
      BuildContext context,
      Tracker trackerToWhichToAddALog,
      VoidCallback rebuildTrackerListCallback) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddLogAlertDialog(trackerToWhichToAddALog, rebuildTrackerListCallback);
      },
    );
  }

  void showExplanationForDisabledButton(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'You can only add one log per day. '
        'If you want to change the log you added, tap the tracker name.',
        style: TextStyle(fontSize: 18.0),
      ),
      duration: Duration(seconds: 5),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
