import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/tracker_list.dart';
import '../widgets/alert_dialogs/rename_tracker_alert_dialog.dart';

void letUserRenameTracker(BuildContext context, String nameOfTracker) {
  showAlertDialogToRenameTracker(context).then((String newTrackerName) {
    if (newTrackerName != null && newTrackerName != '') {
      final trackerListObject = Provider.of<TrackerList>(context);
      trackerListObject.renameTracker(nameOfTracker, newTrackerName);
    }
  });
}

Future<String> showAlertDialogToRenameTracker(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return RenameTrackerAlertDialog();
      });
}
