import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Working with streams'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamController streamController = StreamController();
  StreamSubscription streamSubscription;
  Stream stream;

  String name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = streamController.stream;
    streamSubscription = stream.listen(
            (event) {
              setState(() {
                name = event;
              });
            },
    onError: (error){

    }
    );

    Timer.periodic(Duration(seconds: 1), (timer) {
      streamController.add(timer.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
       child: Text('$name'),
      ),
    );
  }
}
