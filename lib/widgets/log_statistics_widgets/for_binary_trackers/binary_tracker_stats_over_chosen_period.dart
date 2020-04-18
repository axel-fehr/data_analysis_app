import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

import '../styling.dart';

class BinaryTrackerStatsOverChosenPeriod extends StatefulWidget {
  final String trackerName;
  final TextStyle sectionHeadlineTextStyle;

  BinaryTrackerStatsOverChosenPeriod({
    @required this.trackerName,
    @required this.sectionHeadlineTextStyle,
  });

  @override
  _BinaryTrackerStatsOverChosenPeriodState createState() =>
      _BinaryTrackerStatsOverChosenPeriodState();
}

class _BinaryTrackerStatsOverChosenPeriodState
    extends State<BinaryTrackerStatsOverChosenPeriod> {
  // the period with which the statistics will be calculated
  String chosenPeriod = 'Day';
  // TODO: compute and display stats for given period
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          child: LogStatsSectionHeadline(
            textToDisplay: 'Statistics by ',
            sectionHeadlineTextStyle: widget.sectionHeadlineTextStyle,
          ),
          padding: EdgeInsets.only(top: 8.0),
        ),
        DropdownButton<String>(
          value: chosenPeriod,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
//          elevation: 16,
//          style: TextStyle(color: Colors.blue),
          underline: Container(
            height: 1,
            color: Colors.black,
          ),
          onChanged: (String newValue) {
            setState(() {
              chosenPeriod = newValue;
            });
          },
          items: <String>['Day', 'Week', 'Month']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}