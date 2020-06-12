import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/enumerations/user_interaction.dart';

import '../providers/tracker_list.dart';
import '../classes/tracker.dart';
import '../classes/user_interaction_database.dart';
import '../widgets/bulleted_list.dart';
import '../enumerations/tracker_type.dart';

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
      decoration: InputDecoration.collapsed(
          hintText: 'Example: "number of hours I slept"',
          border: UnderlineInputBorder()),
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

    TrackerTypeChoiceList trackerTypeChoiceList = TrackerTypeChoiceList();
    const double defaultContentPaddingValue = 20.0;

    return AlertDialog(
      title: const Text('What do you want to track?'),

      // no horizontal padding for all elements because the list tiles already
      // have horizontal padding, so horizontal padding is added to all widgets
      // except the list tiles
      contentPadding:
          EdgeInsets.symmetric(vertical: defaultContentPaddingValue),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultContentPaddingValue),
              child: enterTrackerNameTextField,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: showTrackerNameWarning ? _trackerNameWarning : Text(''),
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  trackerTypeChoiceList,
                ],
              ),
              // TODO: figure out a way to adjust the size and width to the content without having to set a specific height and width
              height: 200,
              width: 300,
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
              // check if the tracker is the first very first one created
              bool userCreatedHisFirstTracker = false;
              UserInteractionDatabase userInteractionDatabase =
                  Provider.of<UserInteractionDatabase>(context);
              if (!userInteractionDatabase
                  .isRecorded(UserInteraction.createdTracker)) {
                userCreatedHisFirstTracker = true;
                userInteractionDatabase
                    .recordUserInteraction(UserInteraction.createdTracker);
              }

              Tracker trackerToAdd;
              switch (trackerTypeChoiceList.chosenTrackerType) {
                case TrackerType.yesNo:
                  trackerToAdd = Tracker<bool>(enteredTrackerName,
                      initializeWithEmptyLogList: true);
                  break;
                case TrackerType.integer:
                  trackerToAdd = Tracker<int>(enteredTrackerName,
                      initializeWithEmptyLogList: true);
                  break;
                case TrackerType.decimal:
                  trackerToAdd = Tracker<double>(enteredTrackerName,
                      initializeWithEmptyLogList: true);
                  break;
                default:
                  throw('Unexpected tracker type: ${trackerTypeChoiceList.chosenTrackerType}');
              }
              Navigator.of(context).pop(trackerToAdd);

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

class TrackerTypeChoiceList extends StatefulWidget {
  TrackerType _chosenTrackerType = TrackerType.yesNo;
  TrackerType get chosenTrackerType => _chosenTrackerType;

  @override
  _TrackerTypeChoiceListState createState() => _TrackerTypeChoiceListState();
}

class _TrackerTypeChoiceListState extends State<TrackerTypeChoiceList> {
  @override
  Widget build(BuildContext context) {
    void setChosenTrackerType(TrackerType type) {
      setState(() {
        widget._chosenTrackerType = type;
      });
    }

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        RadioListTile(
          title: Text('Yes/No'),
          subtitle: Text('Example: whether you exercised or not'),
          value: TrackerType.yesNo,
          groupValue: widget._chosenTrackerType,
          onChanged: (TrackerType value) => setChosenTrackerType(value),
        ),
        RadioListTile(
          title: Text('Whole numbers'),
          subtitle: Text(
              'Examples: 1, 2, 3 etc. (e.g. how many cups of coffee you drank)'),
          value: TrackerType.integer,
          groupValue: widget._chosenTrackerType,
          onChanged: (TrackerType value) => setChosenTrackerType(value),
        ),
        RadioListTile(
          title: Text('Decimal numbers'),
          subtitle: Text(
              'Examples: 0.2, 82.7, 7.5 etc. (e.g. how many hours you slept)'),
          value: TrackerType.decimal,
          groupValue: widget._chosenTrackerType,
          onChanged: (TrackerType value) => setChosenTrackerType(value),
        ),
      ],
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
