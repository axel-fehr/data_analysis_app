import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
Plan:
1. DONE make code below work (should work already but check)
2. SKIP show list on tap
3. DONE make it work with a list with arbitrary items and the button (without the alert dialog)
4. make it work with the list and the alert dialog (i.e. name of item must be from the alert dialog)
5. make it work with multiple items that are added to the list one-by-one
*/

class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}


class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  bool showList = false;

  void _addVariableToList(String variableName) {
    // TODO: check if input name is null or empty and change visibility based on that
    // TODO: show item with name of passed value
    setState(() {
      showList = true;
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
                child: TrackingVariablesList(),
                width: 200,
                height: 200,
              ),
              visible: showList,
            )
          ],
        )
      ),
      floatingActionButton: AddVariableToTrackButton(handleButtonPress: _addVariableToList),
    );
  }
}
// NOTE: could for example call a function in one widget in the parent widget, and pass the value to the other child widget
// TODO: could this be made stateless since it gets rendered again anyway since the parent is stateful?
class TrackingVariablesList extends StatefulWidget {
  @override
  TrackingVariablesListState createState() => TrackingVariablesListState();
}


class TrackingVariablesListState extends State<TrackingVariablesList> {
  final _listTextStyle = TextStyle(fontSize: 30.0);
  var list = ListView();

  void addVariableToList(String variableName) {
    setState(() {
      //TODO: implement the addition of a variable with the given name
    });
  }

  @override
  Widget build(BuildContext context) {
    return list;
//    return _buildVariablesList();
//    return ListView(
//      children: <Text>[Text(this._variableName, style: _listTextStyle),
//        Text('Var2', style: _listTextStyle),
//        Text('Var3', style: _listTextStyle)],
//    );
  }
}


class AddVariableToTrackButton extends StatelessWidget{
  final handleButtonPress;

  AddVariableToTrackButton({Key key, @required this.handleButtonPress}) : super(key: key); // TODO: UNDERSTAND THIS

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
    return FloatingActionButton(
      child: Text(
        '+',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
      ),
      onPressed: () {
        createAlertDialog(context).then((onValue){
          SnackBar mySnackBar = SnackBar(content: Text("Hello $onValue",));
          Scaffold.of(context).showSnackBar(mySnackBar);
          handleButtonPress(onValue);
        });
        // TODO: pass name of variable to list builder
        // TODO: set visibility of text to false IF a tracking variable is created
      },
    );
  }
}
