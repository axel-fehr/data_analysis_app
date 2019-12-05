import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
Plan:
1. DONE make code below work (should work already but check)
2. SKIP show list on tap
2. make it work with the list and the button (without the alert dialog)
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
              child: TrackingVariablesList(), // TODO: add stateful widget class for list of tracking variables
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
  final _suggestions = <Text>[];

  @override
  Widget build(BuildContext context) {
    return _buildVariablesList();
  }

  Widget _buildVariablesList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10));
            _suggestions.add(Text("I'm a list item!"));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  // #docregion _buildRow
  Widget _buildRow(Text trackingVariableName) {
    return ListTile(
      title: trackingVariableName,
    );
  }
}

/*
// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
// #enddocregion build
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
// #enddocregion MyApp

// #docregion RWS-var
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
  // #enddocregion _buildRow

// #enddocregion RWS-build
// #docregion RWS-var
}
// #enddocregion RWS-var
*/

/*
class TrackingVariablesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracked Variables"),
      ),
      body: Center(
        widthFactor: 1.0,
        child: SizedBox(
          width: 300.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Variable name',
                  ),
                ),
              ),
              RaisedButton(
                child: Text('+'),
                onPressed: null,
                ),
              ],
            )
        )
      ),
    );
  }
}*/
