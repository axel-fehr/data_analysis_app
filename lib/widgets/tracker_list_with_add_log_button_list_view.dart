import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './tracker_list_view.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';


class TrackerListWithAddLogButtonListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final numTrackers = Provider.of<TrackerList>(context).trackers.length;
    final trackerListView = TrackerListView();

    // TODO: use numTrackers to create a list of buttons that add logs and put it next to the list of tracker names

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: trackerListObject.trackers,
    );
  }
}
