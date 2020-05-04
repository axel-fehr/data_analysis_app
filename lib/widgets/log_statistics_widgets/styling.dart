import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class SectionHeadline extends StatelessWidget {
  static const TextStyle sectionHeadlineTextStyle = TextStyle(
      fontSize: 16,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold);
  final String textToDisplay;

  const SectionHeadline({
    @required this.textToDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[
                  Text(
                    textToDisplay,
                    style: sectionHeadlineTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 8.0),
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
        child: Text(_textToDisplay, style: TextStyle(fontSize: 16),),
        padding: const EdgeInsets.only(top: 8.0, left: 16.0),
      ),
      alignment: Alignment.centerLeft,
    );
  }
}

class BulletPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('•', style: TextStyle(fontSize: 30),);
  }
}

