import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrackingVariablesRoute extends StatelessWidget {

  Future<String> createAlertDialog(BuildContext context){
    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Your name?'),
        content: TextField(
          controller: customController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text('Submit'),
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
        child: Text(
          'You haven\'t created a tracking variable yet.'
          '\nGo ahead and create one!',
          style: TextStyle(fontSize: 16),
        ),
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
        },
      ),
    );
  }
}

// TODO: use modal route for the popup!

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
