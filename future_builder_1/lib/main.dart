import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart';
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

  Future response = get('https://jsonplaceholder.typicode.com/todos/1').then((value) {

    Map<String, dynamic> data = jsonDecode(value.body);

    return data['userId'];
  });

  Future<int> generateResponse () async{

    int id = await get('https://jsonplaceholder.typicode.com/todos/1').then((value) {

      Map<String, dynamic> data = jsonDecode(value.body);

      return data['userId'];
    });
    return id;
  }

  Future<DateTime> getTime () async{

    DateTime dateTime = DateTime.now();

    return dateTime;
  }

  Stream _bids;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bids = (() async* {
      DateTime time = await getTime();
      yield time;
    })();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: response,
              builder: (context, snapshot){
                String value = 'Waiting for data';
                if (snapshot.hasData){
                  value = snapshot.data.toString();
                }else if (snapshot.hasError){
                  value = 'Unable to load data';
                }
                return Text('$value');
              },
            ),
            FutureBuilder(
              future: getTime(),
              builder: (context, snapshot){
                String value;
                if (snapshot.connectionState == ConnectionState.waiting){
                  value = 'Waiting';
                }else if (snapshot.connectionState == ConnectionState.done){
                  if (snapshot.hasData){
                    value = snapshot.data.toString();
                  }else{
                    value = 'Unable to load data';
                  }
                }
                return Text('$value');
              },
            ),
            FutureBuilder(
              future: generateResponse(),
              builder: (context, snapshot){
                String value;
                if (snapshot.connectionState == ConnectionState.waiting){
                  value = 'Waiting';
                }else if (snapshot.connectionState == ConnectionState.done){
                  if (snapshot.hasData){
                    value = snapshot.data.toString();
                  }else{
                    value = 'Unable to load data';
                  }
                }
                return Text('$value');
              },
            ),
            StreamBuilder(
              stream: _bids,
              builder: (context, snapshot){

                return Text('${snapshot.data}');
              },
            )
          ],
        ),
      ),
    );
  }
}
