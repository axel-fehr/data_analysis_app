import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class LogStatsSectionHeadline extends StatelessWidget {
  final TextStyle sectionHeadlineTextStyle;
  final String textToDisplay;

  LogStatsSectionHeadline({
    @required this.textToDisplay,
    @required this.sectionHeadlineTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        child: Text(
          textToDisplay,
          style: sectionHeadlineTextStyle,
        ),
        padding: EdgeInsets.only(left: 8.0),
      ),
      alignment: Alignment.center,
    );
  }
}

class StatisticWithPadding extends StatelessWidget {
  final String _textToDisplay;

  StatisticWithPadding(this._textToDisplay);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        child: Text(_textToDisplay),
        padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}