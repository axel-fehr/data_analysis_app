import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DailySurveyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Survey"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('+'),
          onPressed: null,
        ),
      ),
    );
  }
}
