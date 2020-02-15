import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_list.dart';

class TrackerListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trackerListObject = Provider.of<TrackerList>(context);
    final List<Text> trackerNameList = <Text>[];
    final _listTextStyle = TextStyle(fontSize: 35.0);

    trackerListObject.trackerNames.forEach((name) => trackerNameList.add(Text(
          name,
          style: _listTextStyle,
        )));

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: trackerNameList,
    );

    // TODO: instead of showing the name of the tracker as text, make the text link to the page where ...
    // logs can be seen and edited etc.
  }
}
