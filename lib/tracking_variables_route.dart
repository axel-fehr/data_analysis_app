import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import './providers/show_list_of_trackers.dart';

/*
Plan:
1. DONE make code below work (should work already but check)
2. SKIP show list on tap
3. DONE make it work with a list with arbitrary items and the button (without the alert dialog)
4. make it work with the list and the alert dialog (i.e. name of item must be from the alert dialog)
5. make it work with multiple items that are added to the list one-by-one
*/

/* tmp:
1. use provider for show list
2. use provider for variable list
*/

class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}


class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  bool showList = false;
//  var variablesList = TrackingVariablesList();

//  void _addVariableToList(String variableName) {
  void _addVariableToList() {
    // TODO: check if input name is null or empty and change visibility based on that
    // TODO: show item with name of passed value (*list should probably be provided by a provider*)
    setState(() {
//      variablesList.createState().addVariableToList(variableName);
//      showList = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (showTrackerListContext) => ShowListOfTrackers(show: false),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tracked Variables"),
        ),
        body: Center(child: ScreenCenter()),
        floatingActionButton: AddVariableToTrackButton(handleButtonPress: _addVariableToList),
      ),
    );
  }
}

class ScreenCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final showListObject = Provider.of<ShowListOfTrackers>(context);
    final showList = showListObject.show;
    return Center(
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
              child: TrackingVariablesList(), //variablesList,
              width: 200,
              height: 200,
            ),
            visible: showList,
          )
        ],
      ),
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
  var _list = List<Text>();
//  list.add()

//  void addVariableToList(String variableName) {
//    setState(() {
//      _list.add(Text(variableName, style: _listTextStyle));
//      //TODO: implement the addition of a variable with the given name
//    });
//  }

  @override
  Widget build(BuildContext context) {
//    return ListView(children: _list);
//    return _buildVariablesList();
    return ListView(
      children: <Text>[Text('Var1', style: _listTextStyle),
        Text('Var2', style: _listTextStyle),
        Text('Var3', style: _listTextStyle)],
    );
  }
}


class AddVariableToTrackButton extends StatelessWidget{
  final handleButtonPress;

  AddVariableToTrackButton({Key key, @required this.handleButtonPress}) : super(key: key); // TODO: UNDERSTAND THIS, does it even make sense to wrap a required parameter with curly braces?

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
//          handleButtonPress(onValue);
//          handleButtonPress();
          final showListObject = Provider.of<ShowListOfTrackers>(context);
          showListObject.toggleShow(); // TODO: set show to true here, to make sure the list is shown, use a setter instead of the toggle function
        });
        // TODO: pass name of variable to list builder
        // TODO: set visibility of text to false IF a tracking variable is created
      },
    );
  }
}
