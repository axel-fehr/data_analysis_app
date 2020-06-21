import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app/enumerations/user_interaction.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../classes/user_interaction_database.dart';
import '../../enumerations/tracker_type.dart';
import './explain_app_basics_alert_dialog.dart';

class AddTrackerAlertDialog extends StatefulWidget {
  @override
  _AddTrackerAlertDialogState createState() => _AddTrackerAlertDialogState();
}

class _AddTrackerAlertDialogState extends State<AddTrackerAlertDialog> {
  /// shown when a tracker with the entered name already exists
  static const Text _trackerNameWarning = Text(
    'Name already exists!',
    style: TextStyle(color: Colors.redAccent),
  );

  final TextEditingController _customController = TextEditingController();

  /// determines whether a warning is shown that tells the user that he must
  /// not add a tracker with a name that already exists
  bool _showTrackerNameWarning = false;

  final TrackerTypeChoiceList _trackerTypeChoiceList = TrackerTypeChoiceList();

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
            _showTrackerNameWarning = true;
          });
        }
        // removes the warning if entered text is not an existing name
        else if (_showTrackerNameWarning = true) {
          setState(() {
            _showTrackerNameWarning = false;
          });
        }
      },
    );

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
                child: _showTrackerNameWarning ? _trackerNameWarning : Text(''),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultContentPaddingValue),
              child: Text(
                'Tracker type:',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _trackerTypeChoiceList,
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
              switch (_trackerTypeChoiceList.chosenTrackerType) {
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
                  throw ('Unexpected tracker type: ${_trackerTypeChoiceList.chosenTrackerType}');
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
        return const ExplainAppBasicsAlertDialog();
      },
      // Disables the dismissal of the alert dialog by tapping the area outside
      // it. This prevents the user from accidentally dismissing it before
      // having read everything.
      barrierDismissible: false,
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
          title: const Text('Yes/No'),
          subtitle: const Text('Example: whether you exercised or not'),
          value: TrackerType.yesNo,
          groupValue: widget._chosenTrackerType,
          onChanged: (TrackerType value) => setChosenTrackerType(value),
        ),
        RadioListTile(
          title: const Text('Whole numbers'),
          subtitle: const Text(
              'Examples: 1, 2, 3 etc. (e.g. how many cups of coffee you drank)'),
          value: TrackerType.integer,
          groupValue: widget._chosenTrackerType,
          onChanged: (TrackerType value) => setChosenTrackerType(value),
        ),
        RadioListTile(
          title: const Text('Decimal numbers'),
          subtitle: const Text(
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
