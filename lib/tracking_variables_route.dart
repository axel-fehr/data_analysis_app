import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:english_words/english_words.dart';

/*
Plan:
1. DONE make code below work (should work already but check)
2. SKIP show list on tap
2. ADD WORD ITEMS TO LIST FIRST make it work with the list and the button (without the alert dialog)
3. make it work with the list and the alert dialog
4. show the list with an entry whose text is the name entered in the alert dialog
*/

class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}

class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  bool showList = false;

  void _handleButtonPressed(bool newValue) {
    setState(() {
      showList = newValue;
    });
  }

  Future<String> createAlertDialog(BuildContext context){
    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Variable name'),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Add'),
            onPressed: (){
              Navigator.of(context).pop(customController.text.toString());
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracked Variables"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Visibility(
              child: Text(
                'You haven\'t created a tracking variable yet.'
                    '\nGo ahead and create one!',
                style: TextStyle(fontSize: 16),
              ),
              visible: !showList,
            ),
            Visibility(
              child: Container(
                child: TrackingVariablesList(), // TODO: add stateful widget class for list of tracking variables
                width: 200,
                height: 200,
              ),
              visible: showList,
            )
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
        onPressed: () {
          setState(() {
            showList = !showList;
          });
//          createAlertDialog(context).then((onValue){
//            SnackBar mySnackBar = SnackBar(content: Text("Hello $onValue",));
//            Scaffold.of(context).showSnackBar(mySnackBar);
//          });
          // TODO: set visibility of text to false IF a tracking variable is created
        },
      ),
    );
  }
}


class TrackingVariablesList extends StatefulWidget {
  @override
  TrackingVariablesListState createState() => TrackingVariablesListState();
}

class TrackingVariablesListState extends State<TrackingVariablesList> {
  final _textStyle = TextStyle(fontSize: 30.0);

  @override
  Widget build(BuildContext context) {
//    return _buildVariablesList();
    return ListView(
      children: <Text>[Text('Var1', style: _textStyle),
                       Text('Var2', style: _textStyle),
                       Text('Var3', style: _textStyle)],
    );
  }
}

