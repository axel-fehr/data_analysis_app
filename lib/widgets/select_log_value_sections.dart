/// This file contains widgets that can be used to choose different types of
/// log values (e.g. Boolean, int or double).

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../classes/tracker.dart';
import '../classes/log.dart';

class ChooseBooleanLogValueSection extends StatefulWidget {
  String _chosenValue = Log.boolToYesOrNo(true);

  ChooseBooleanLogValueSection();

  String get chosenValue => _chosenValue;

  @override
  _ChooseBooleanLogValueSectionState createState() =>
      _ChooseBooleanLogValueSectionState();
}

class _ChooseBooleanLogValueSectionState
    extends State<ChooseBooleanLogValueSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: DropdownButton<String>(
                value: widget._chosenValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    widget._chosenValue = newValue;
                  });
                },
                items: <String>[
                  Log.boolToYesOrNo(true),
                  Log.boolToYesOrNo(false)
                ].map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ChooseIntegerLogValueSection extends StatefulWidget {
  final TextEditingController _logValueTextFieldController =
      TextEditingController();

  String get chosenValueAsString => _logValueTextFieldController.text;

  ChooseIntegerLogValueSection();

  @override
  _ChooseIntegerLogValueSectionState createState() =>
      _ChooseIntegerLogValueSectionState();
}

class _ChooseIntegerLogValueSectionState
    extends State<ChooseIntegerLogValueSection> {
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
  /// value is not parsable (e.g. when there is more than one minus sign)
  bool _showInputNotParsableWarning = false;

  @override
  void initState() {
    super.initState();
    widget._logValueTextFieldController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final TextField logValueTextField = TextField(
      controller: widget._logValueTextFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        // accept digits and minus signs
        WhitelistingTextInputFormatter(RegExp('[0-9-]')),
      ],
      // Only numbers can be entered
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
      ),
      textAlign: TextAlign.center,
      showCursor: false,
      onTap: () {
        // resets the input value so that a number can be entered immediately
        // without having to delete the '0' that the field is initialized with
        widget._logValueTextFieldController.text = '';

        if (_showInputNotParsableWarning) {
          // do not show the warning since the entered text was reset
          setState(() {
            _showInputNotParsableWarning = false;
          });
        }
      },
      onChanged: (String enteredValue) {
        // keeps the cursor behind the last digit
        widget._logValueTextFieldController.selection =
            TextSelection.fromPosition(
          TextPosition(
            offset: widget._logValueTextFieldController.text.length,
          ),
        );

        try {
          // used to test whether the input is parable as a number
          int parsedLogValue = int.parse(enteredValue);

          if (_showInputNotParsableWarning) {
            // do not show the warning since the entered value is parsable
            setState(() {
              _showInputNotParsableWarning = false;
            });
          }
        } on Exception {
          if (!_showInputNotParsableWarning) {
            setState(() {
              _showInputNotParsableWarning = true;
            });
          }
        }
      },
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
        int enteredValue = int.parse(widget._logValueTextFieldController.text);
        widget._logValueTextFieldController.text = '${enteredValue - 1}';
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
        int enteredValue = int.parse(widget._logValueTextFieldController.text);
        widget._logValueTextFieldController.text = '${enteredValue + 1}';
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        Visibility(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: inputNotParsableWarning,
          ),
          visible: _showInputNotParsableWarning,
        ),
      ],
    );
  }
}

class ChooseDecimalLogValueSection extends StatefulWidget {
  final TextEditingController _logValueTextFieldController =
      TextEditingController();

  String get chosenValueAsString => _logValueTextFieldController.text;

  ChooseDecimalLogValueSection();

  @override
  _ChooseDecimalLogValueSectionState createState() =>
      _ChooseDecimalLogValueSectionState();
}

class _ChooseDecimalLogValueSectionState
    extends State<ChooseDecimalLogValueSection> {
  /// a text that tells the user that the entered text for the value is not
  /// parsable as a number
  static const Text inputNotParsableWarning = Text(
    'Please enter a valid number',
    style: TextStyle(color: Colors.redAccent),
  );

  /// determines whether a warning is shown that tells the user the entered
  /// value is not parsable (e.g. when there is more than one minus sign)
  bool _showInputNotParsableWarning = false;

  @override
  void initState() {
    super.initState();
    widget._logValueTextFieldController.text = '0.0';
  }

  @override
  Widget build(BuildContext context) {
    final TextField logValueTextField = TextField(
      controller: widget._logValueTextFieldController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        // accept digits, minus signs and points
        WhitelistingTextInputFormatter(RegExp('[0-9-.]')),
      ],
      // Only numbers can be entered
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(8.0),
      ),
      textAlign: TextAlign.center,
      showCursor: false,
      onTap: () {
        // resets the input value so that a number can be entered immediately
        // without having to delete the '0' that the field is initialized with
        widget._logValueTextFieldController.text = '';

        if (_showInputNotParsableWarning) {
          // do not show the warning since the entered text was reset
          setState(() {
            _showInputNotParsableWarning = false;
          });
        }
      },
      onChanged: (String enteredValue) {
        // keeps the cursor behind the last digit
        widget._logValueTextFieldController.selection =
            TextSelection.fromPosition(
          TextPosition(
            offset: widget._logValueTextFieldController.text.length,
          ),
        );

        try {
          // used to test whether the input is parable as a number
          int parsedLogValue = int.parse(enteredValue);

          if (_showInputNotParsableWarning) {
            // do not show the warning since the entered value is parsable
            setState(() {
              _showInputNotParsableWarning = false;
            });
          }
        } on Exception {
          if (!_showInputNotParsableWarning) {
            setState(() {
              _showInputNotParsableWarning = true;
            });
          }
        }
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
        Visibility(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: inputNotParsableWarning,
          ),
          visible: _showInputNotParsableWarning,
        ),
      ],
    );
  }
}
