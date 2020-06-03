import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../utils/general.dart' as utils;
import '../providers/tracker_list.dart';
import '../widgets/tracker_list_with_add_log_button_list_view.dart';
import '../widgets/disclaimer_or_warning.dart';
import '../widgets/add_tracker_alert_dialog.dart';

class TrackerListRoute extends StatefulWidget {
  @override
  _TrackerListRouteState createState() => _TrackerListRouteState();
}

class _TrackerListRouteState extends State<TrackerListRoute>
    with WidgetsBindingObserver {
  // used to store the date of the last widget rebuild.
  DateTime _dateOfLastRebuild;

  @override
  Widget build(BuildContext context) {
    _dateOfLastRebuild = utils.convertTimeStampToDate(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackers'),
      ),
      body: Content(),
    );
  }

  /// Rebuilds the widget when the app has been in the background and is resumed
  /// again, if the date of the last rebuild is not the current date.
  ///
  /// This is necessary to make sure the add log buttons become active again on
  /// the next day (if there isn't a log with that date already), if the app has
  /// been in the background since a previous date. If this is not done, the add
  /// log buttons are inactive the next day even when there aren't any logs with
  /// the current date.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    DateTime currentDate = utils.convertTimeStampToDate(DateTime.now());
    if (state == AppLifecycleState.resumed &&
        _dateOfLastRebuild != currentDate) {
      // trigger rebuild to update add log buttons
      setState(() {});
    }
  }

  // overwritten to add the observer of the app lifecycle state when the state
  // is initialized (to trigger the rebuild when the app is active again)
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // overwritten to also dispose the observer of the app lifecycle state
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<TrackerList>(context).trackers.isEmpty) {
      return NoTrackerPage();
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: TrackerListWithAddLogButtonListView(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DisclaimerOrWarning(
                    text:
                        'The information provided on this app is not medical advice.',
                  ),
                ),
                Align(
                  child: AddTrackerButton(),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

/// The page that is shown when the user hasn't created a tracker yet.
class NoTrackerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: const Center(
            child: Text(
              'You haven\'t created a tracker yet.'
              '\nGo ahead and create one!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddTrackerButton(),
          ),
        ),
      ],
    );
  }
}

class AddTrackerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Text(
        '+',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
      ),
      onPressed: () {
        showAlertDialogToAddTracker(context).then((onValue) {
          if (onValue != null && onValue != '') {
            final trackerListObject = Provider.of<TrackerList>(context);
            trackerListObject.addTracker(onValue);
          }
        });
      },
    );
  }

  Future<String> showAlertDialogToAddTracker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AddTrackerAlertDialog();
        });
  }
}
