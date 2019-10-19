import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DataAnalysisRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Analysis"),
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