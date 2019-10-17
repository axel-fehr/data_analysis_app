import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: AppHome()
    );
  }

  void _printMessage() {
    print('Button pressed');
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Message'),
      ),
    );
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Your App!'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text('Tracked Variables'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackingVariablesRoute()),
              );
            },
          ),
          RaisedButton(
            child: Text('Data Analysis'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DataAnalysisRoute()),
              );
            },
          ),
          RaisedButton(
            child: Text('Daily Survey'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DailySurveyRoute()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _printMessage() {
    print('Button pressed');
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Message'),
      ),
    );
  }
}

class TrackingVariablesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracked Variables"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('+'),
          onPressed: null,
        ),
      ),
    );
  }
}

class DataAnalysisRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Analysis"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('+'),
          onPressed: null,
        ),
      ),
    );
  }
}

class DailySurveyRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Survey"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('+'),
          onPressed: null,
        ),
      ),
    );
  }
}
