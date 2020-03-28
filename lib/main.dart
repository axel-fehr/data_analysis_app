import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'routes/app_home_route.dart';
import './providers/tracker_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  create: (trackerListContext) => trackerList,
                ),
              ],
              child: MaterialApp(home: AppHome()),
            );
          }
        });
  }
}
