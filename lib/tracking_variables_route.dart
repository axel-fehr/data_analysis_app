import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrackingVariablesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracked Variables"),
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