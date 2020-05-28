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

class LoadingDataFromDiskScreen extends StatelessWidget {
  final TrackerList _trackerList;
  final UserInteractionDatabase _userInteractionDatabase;

  LoadingDataFromDiskScreen()
      : _trackerList = TrackerList(),
        _userInteractionDatabase = UserInteractionDatabase();

  List<Future> getFuturesToCompleteBeforeAppStart() {
    List<Future> futuresToCompleteBeforeAppStart = [];

    Future<List> trackerDataLoadedFromDisk =
        _trackerList.getFuturesToCompleteBeforeAppStart();
    futuresToCompleteBeforeAppStart.add(trackerDataLoadedFromDisk);

    Future<Database> userInteractionDatabase =
        _userInteractionDatabase.initDatabase();
    futuresToCompleteBeforeAppStart.add(userInteractionDatabase);

    Future<Map<String,int>> loadedDatabaseContent = userInteractionDatabase
        .then((value) => _userInteractionDatabase.initializeDatabaseContent());
    futuresToCompleteBeforeAppStart.add(loadedDatabaseContent);

    return futuresToCompleteBeforeAppStart;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait(getFuturesToCompleteBeforeAppStart()),
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
}
