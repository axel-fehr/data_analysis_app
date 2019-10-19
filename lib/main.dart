import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'tracking_variables_route.dart';
import 'data_analysis_route.dart';
import 'survey_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AppHome()
    );
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Your App!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Tracked Variables'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrackingVariablesRoute()),
                );
              },
            ),
            RaisedButton(
              child: Text('Data Analysis'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataAnalysisRoute()),
                );
              },
            ),
            RaisedButton(
              child: Text('Daily Survey'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailySurveyRoute()),
                );
              },
            ),
          ],
        ),
      )
    );
  }
}

// DONE 1. center the buttons on the home route
// DONE 2. put the code for each route in a different file (check the style guide!)
// DONE 3. get a linter for dart
// TODO: 4. then add a text field to the other route
