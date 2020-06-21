import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../bulleted_list.dart';

/// An alert dialog that explains the basics of the app to the user so that he
/// knows how to use the app.
class ExplainAppBasicsAlertDialog extends StatelessWidget {

  const ExplainAppBasicsAlertDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Things you should know'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const BulletedList([
              'You can add one log per day per tracker',
              'Tap on a tracker in the list to see more detailed statistics',
              "These statistics aren't very insightful at the beginning since "
                  'there is not a lot of data yet. But the more logs you add '
                  'over time, the more insightful these statistics will become!'
            ]),
            Align(
              child: FlatButton(
                child: const Text(
                  'Got it',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              alignment: Alignment.centerRight,
            ),
          ],
        ),
      ),
    );
  }
}