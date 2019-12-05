


class TrackingVariablesRoute extends StatefulWidget {
  @override
  _TrackingVariablesRouteState createState() => _TrackingVariablesRouteState();
}

class _TrackingVariablesRouteState extends State<TrackingVariablesRoute> {
  bool showList = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      showList = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapboxB(
        showList: showList,
        onChanged: _handleTapboxChanged,
      ),
    );
  }

/*
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
              visible: true,
            ),
            Visibility(
              child: TrackingVariablesList(), // TODO: add stateful widget class for list of tracking variables
              visible: false,
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
          createAlertDialog(context).then((onValue){
            SnackBar mySnackBar = SnackBar(content: Text("Hello $onValue",));
            Scaffold.of(context).showSnackBar(mySnackBar);
          });
          // TODO: set visibility of text to false IF a tracking variable is created
        },
      ),
    );
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
  */
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