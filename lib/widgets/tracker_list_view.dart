import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';

class TrackerListView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final trackerListObject = Provider.of<TrackerList>(context);

    return ListView(
      children: trackerListObject.trackers,
    );
  }
}