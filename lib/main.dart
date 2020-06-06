import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'routes/app_home_route.dart';
import './providers/tracker_list.dart';
import './classes/user_interaction_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingDataFromDiskScreen();
  }
}

class LoadingDataFromDiskScreen extends StatefulWidget {
  @override
  _LoadingDataFromDiskScreenState createState() =>
      _LoadingDataFromDiskScreenState();
}

class _LoadingDataFromDiskScreenState extends State<LoadingDataFromDiskScreen> {
  final TrackerList _trackerList = TrackerList();
  final UserInteractionDatabase _userInteractionDatabase =
      UserInteractionDatabase();
  List<Future> _futuresToCompleteBeforeAppStart;

  @override
  void initState() {
    // this is done to get the futures only once (when  the state is
    // initialized) to prevent the data from getting loaded from disk again if
    // the widget rebuilds, which happened before.
    _futuresToCompleteBeforeAppStart = getFuturesToCompleteBeforeAppStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait(_futuresToCompleteBeforeAppStart),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // prevents the app from changing in response to an orientation
            // change of the device. Prevents issues caused when app is used
            // in landscape mode.
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (trackerListContext) => _trackerList,
                ),
                Provider(
                  create: (context) => _userInteractionDatabase,
                ),
              ],
              child: MaterialApp(
                home: AppHome(),
              ),
            );
          }
        });
  }

  List<Future> getFuturesToCompleteBeforeAppStart() {
    List<Future> futuresToCompleteBeforeAppStart = [];

    Future<List> trackerDataLoadedFromDisk =
        _trackerList.getFuturesToCompleteBeforeAppStart();
    futuresToCompleteBeforeAppStart.add(trackerDataLoadedFromDisk);

    Future<Database> userInteractionDatabase =
        _userInteractionDatabase.initDatabase();
    futuresToCompleteBeforeAppStart.add(userInteractionDatabase);

    Future<Map<String, int>> loadedDatabaseContent = userInteractionDatabase
        .then((value) => _userInteractionDatabase.initializeDatabaseContent());
    futuresToCompleteBeforeAppStart.add(loadedDatabaseContent);

    return futuresToCompleteBeforeAppStart;
  }
}
