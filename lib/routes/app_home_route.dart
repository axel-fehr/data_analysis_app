import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'tracker_list_route.dart';
import 'data_analysis_route.dart';
import 'survey_route.dart';

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
                    MaterialPageRoute(
                        builder: (context) => TrackingVariablesRoute()),
                  );
                },
              ),
              RaisedButton(
                child: Text('Data Analysis'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DataAnalysisRoute()),
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
        ));
  }
}