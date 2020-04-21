import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'routes/app_home_route.dart';
import './providers/tracker_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingDataFromDiskScreen();
  }
}

class LoadingDataFromDiskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TrackerList trackerList = TrackerList();
    Future<List> futuresToCompleteBeforeAppStart =
        trackerList.getFuturesToCompleteBeforeAppStart();

    return FutureBuilder(
        future: futuresToCompleteBeforeAppStart,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // TODO: add something here that makes it easy to submit a bug report
            return Center(
                child: Text(
              '${snapshot.error}',
              textDirection: TextDirection.ltr,
            ));
          } else {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (trackerListContext) => trackerList,
                ),
              ],
              child: MaterialApp(
                home: AppHome(),
              ),
            );
          }
        });
  }
}
