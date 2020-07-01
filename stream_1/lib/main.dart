import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StreamController streamController = StreamController.broadcast();
  StreamSubscription streamSubscription;

  Stream getTime() async*{

    while(true){

      DateTime time = DateTime.now();

      await Future.delayed(Duration(seconds: 1));
      yield time;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               MaterialButton(
                 child: Text('Subscibe'),
                 color: Colors.yellow,
                 onPressed: (){
                   Stream stream = streamController.stream;

                   streamSubscription = stream.listen((event) {
                     print('Listened to the stream $event');
                   });
                 },
               ),
                MaterialButton(
                  child: Text('value'),
                  color: Colors.greenAccent,
                  onPressed: (){
                    Stream stream = streamController.stream;
                    streamController.add(10);
                  },
                ),
                MaterialButton(
                  child: Text('UNSUBSCRIBE'),
                  color: Colors.red,
                  onPressed: (){
                    streamSubscription.cancel();
                  },
                )
              ],
            ),
            StreamBuilder(
              stream: getTime(),
              builder: (context, snapshot){
                String value;
                if (snapshot.connectionState == ConnectionState.waiting){
                  value = 'Waiting...';
                }else if (snapshot.connectionState == ConnectionState.done){
                  value = snapshot.data.toString();
                }
                return Text('${DateFormat.jms().format(snapshot.data)}');
              },
            )
          ],
        ),
      ),
    );
  }

  Stream getRandomNumber() async*{

    var random = Random();

    while(true){
      await Future.delayed(Duration(seconds: 1));
      yield random.nextDouble();
    }
  }
}
