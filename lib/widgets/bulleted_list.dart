import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BulletedList extends StatelessWidget {
  final List<String> _listItems;

  const BulletedList(this._listItems);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_listItems.length,
          (index) => TextRowWithBulletPoint(_listItems[index])),
    );
  }
}

class TextRowWithBulletPoint extends StatelessWidget {
  final String _text;

  const TextRowWithBulletPoint(this._text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '•',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // Flexible with Column is needed to make text wrap
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_text),
            ],
          ),
        )
      ],
    );
  }
}
