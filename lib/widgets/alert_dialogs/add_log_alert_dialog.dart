import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../providers/tracker_list.dart';
import '../../classes/tracker.dart';
import '../../classes/log.dart';

/// An alert dialog that is used to add logs to a tracker, regardless of its
/// type.
///
/// It changes depending on the type of the tracker that is passed to it.
class AddLogAlertDialog extends StatelessWidget {
  final Tracker _trackerToWhichToAddLog;

  /// A function that triggers the rebuild of the tracker list and its buttons.
  /// This is needed so that a button can be deactivated until the next day
  /// when a log was added (logs are added only once per day per tracker).
  final VoidCallback _triggerTrackerListRebuild;

  const AddLogAlertDialog(
      this._trackerToWhichToAddLog, this._triggerTrackerListRebuild);

  @override
  Widget build(BuildContext context) {
    switch (_trackerToWhichToAddLog.logType) {
      case bool:
        return AddBooleanLogAlertDialog(
            _trackerToWhichToAddLog, _triggerTrackerListRebuild);
      case int:
        return AddIntegerLogAlertDialog(
            _trackerToWhichToAddLog, _triggerTrackerListRebuild);
      // TODO: add alert dialog for decimal logs
//      case double:
//        return ;
      default:
        throw ('Unexpected log type encountered: ${_trackerToWhichToAddLog.logType}');
    }
  }
}

class AddBooleanLogAlertDialog extends StatelessWidget {
  final Tracker _trackerToWhichToAddLog;
  final VoidCallback _triggerTrackerListRebuild;

  const AddBooleanLogAlertDialog(
      this._trackerToWhichToAddLog, this._triggerTrackerListRebuild);

  @override
  Widget build(BuildContext context) {
    final TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    Widget addFalseLogButton = FlatButton(
      child: const Text('No'),
      onPressed: () {
        listOfTrackers.addLog(_trackerToWhichToAddLog, Log<bool>(false));
        _triggerTrackerListRebuild();
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
      },
    );

    Widget addTrueLogButton = FlatButton(
      child: const Text('Yes'),
      onPressed: () {
        listOfTrackers.addLog(_trackerToWhichToAddLog, Log<bool>(true));
        _triggerTrackerListRebuild();
        Navigator.of(context).pop();
        // triggers rebuild to disable functionality to add logs until the next day
      },
    );

    CupertinoAlertDialog addLogAlertDialog = CupertinoAlertDialog(
      title: const Text('Adding Log'),
      content: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Did "${_trackerToWhichToAddLog.name}" happen today?'),
      ),
      actions: [
        addTrueLogButton,
        addFalseLogButton,
      ],
    );

    return addLogAlertDialog;
  }
}

class AddIntegerLogAlertDialog extends StatefulWidget {
  final Tracker _trackerToWhichToAddLog;
  final VoidCallback _triggerTrackerListRebuild;

  const AddIntegerLogAlertDialog(
      this._trackerToWhichToAddLog, this._triggerTrackerListRebuild);

  @override
  _AddIntegerLogAlertDialogState createState() =>
      _AddIntegerLogAlertDialogState();
}

class _AddIntegerLogAlertDialogState extends State<AddIntegerLogAlertDialog> {
  TextEditingController logValueTextFieldController = TextEditingController();

  /// The height and width of buttons that increment or decrement the log value
  /// when tapped
  static const double incrementDecrementButtonDimensions = 50.0;

  /// a text that tells the user that the entered text for the value is not
  /// parsable as a number
  static const Text inputNotParsableWarning = Text(
    'Please enter a valid number',
    style: TextStyle(color: Colors.redAccent),
  );

  /// determines whether a warning is shown that tells the user the entered
  /// value is not parsable (e.g. when there are two minus signs)
  bool showInputNotParsableWarning = false;

  /// indicates whether the user wanted to add a log with an entered value that
  /// was not parable as a number
  bool userTriedToAddUnparsableLogValue = false;

  @override
  void initState() {
    super.initState();
    logValueTextFieldController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final TrackerList listOfTrackers = Provider.of<TrackerList>(context);

    void addLogWithEnteredValue() {
      int enteredLogValue;
      bool enteredTextForLogValueIsParsable;
      try {
        enteredLogValue = int.parse(logValueTextFieldController.text);
        enteredTextForLogValueIsParsable = true;
      } on FormatException {
        enteredTextForLogValueIsParsable = false;
        print('not an accepted format');
        setState(() {
          userTriedToAddUnparsableLogValue = true;
          showInputNotParsableWarning = true;
        });
      }
      if (enteredTextForLogValueIsParsable) {
        listOfTrackers.addLog(
          widget._trackerToWhichToAddLog,
          Log<int>(enteredLogValue),
        );
        widget._triggerTrackerListRebuild();
        Navigator.of(context).pop();
      }
    }

    final TextField logValueTextField = TextField(
      controller: logValueTextFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        // accept digits and minus signs
        WhitelistingTextInputFormatter(RegExp('[0-9-]')),
      ], // Only numbers can be entered
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
      ),
      textAlign: TextAlign.center,
      showCursor: false,
      onTap: () {
        // resets the input value so that a number can be entered immediately
        // without having to delete the '0' that the field is initialized with
        logValueTextFieldController.text = '';

        if (userTriedToAddUnparsableLogValue && showInputNotParsableWarning) {
          // do not show the warning since the entered text was reset
          setState(() {
            showInputNotParsableWarning = false;
          });
        }
      },
      onChanged: (String enteredValue) {
        // keeps the cursor behind the last digit
        logValueTextFieldController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: logValueTextFieldController.text.length,
          ),
        );

        try {
          // used to test whether the input is parable as a number
          int parsedLogValue = int.parse(enteredValue);

          if (userTriedToAddUnparsableLogValue && showInputNotParsableWarning) {
            // do not show the warning since the entered value is parsable
            setState(() {
              showInputNotParsableWarning = false;
            });
          }
        } on Exception {
          if (userTriedToAddUnparsableLogValue &&
              !showInputNotParsableWarning) {
            setState(() {
              showInputNotParsableWarning = true;
            });
          }
        }
      },
      onSubmitted: (String textFieldInput) => addLogWithEnteredValue(),
    );

    final InkWell decrementValueButton = InkWell(
      child: Container(
        height: incrementDecrementButtonDimensions,
        width: incrementDecrementButtonDimensions,
        child: const Icon(
          Icons.remove,
          size: 28,
        ),
      ),
      onTap: () {
        // decrement the value by 1
        int enteredValue = int.parse(logValueTextFieldController.text);
        logValueTextFieldController.text = '${enteredValue - 1}';
      },
    );

    final InkWell incrementValueButton = InkWell(
      child: Container(
        height: incrementDecrementButtonDimensions,
        width: incrementDecrementButtonDimensions,
        child: const Icon(
          Icons.add,
          size: 28,
        ),
      ),
      onTap: () {
        // increment the value by 1
        int enteredValue = int.parse(logValueTextFieldController.text);
        logValueTextFieldController.text = '${enteredValue + 1}';
      },
    );

    const Text alertDialogTitle = Text('Adding log');
    Widget alertDialogContent = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child:
                Text('Value of "${widget._trackerToWhichToAddLog.name}" today'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              decrementValueButton,
              Container(
                child: logValueTextField,
                width: 50,
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 2.0,
                  ),
                ),
              ),
              incrementValueButton,
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: showInputNotParsableWarning
                ? inputNotParsableWarning
                : Text(''),
          ),
        ],
      ),
    );

    final FlatButton addLogButton = FlatButton(
      child: const Text(
        'Add',
        style: TextStyle(color: Colors.blue),
      ),
      onPressed: () => addLogWithEnteredValue(),
    );

    return AlertDialog(
      title: Center(child: alertDialogTitle),
      content: alertDialogContent,
      actions: <Widget>[addLogButton],
    );
  }
}
