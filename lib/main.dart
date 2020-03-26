import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'routes/tracker_list_route.dart';
import 'routes/data_analysis_route.dart';
import 'routes/survey_route.dart';
import './providers/tracker_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: CLEAN THIS CODE!
    TrackerList trackerList = new TrackerList();
    return FutureBuilder<String>(
        future: trackerList.loadTrackersFromDisk(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Text("ERROR: ${snapshot.error}");
          }
          else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (trackerListContext) => trackerList,),
              ],
              child: MaterialApp(home: AppHome()),
            );
          }
        }
    );
  }
}

// TODO: put this in a separate file the routes folder
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
