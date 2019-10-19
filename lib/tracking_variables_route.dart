import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrackingVariablesRoute extends StatelessWidget {
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
        onPressed: null,
      ),
    );
  }
}

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
