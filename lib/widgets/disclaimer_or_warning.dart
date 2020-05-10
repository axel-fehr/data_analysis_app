import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class DisclaimerOrWarning extends StatelessWidget {
  final String text;

  const DisclaimerOrWarning({@required this.text});

  static const Color _color = Colors.black45;
  static const double _size = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.warning,
            size: _size,
            color: _color,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: _size, color: _color),
          ),
        ],
      ),
    );
  }
}
