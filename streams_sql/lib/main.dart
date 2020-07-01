import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      home: MyHomePage(title: 'Streams with SQL'),
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

  List displayList = List();

  Future<Database> database;
  initializeDB() async{

    database = openDatabase(
      join(await getDatabasesPath(), 'streams.db'),
      version: 1,
      onCreate: (db, version){

        return db.execute("CREATE TABLE STREAMS(name TEXT)");
      }
    );
  }

  Future<void> insert(String name) async{

    Database db = await database;

    await db.insert('STREAMS', {
      'name': name,
    });

  }
  void insertData() async{

    await insert('Asad');

  }

  Future<List<Map<String, dynamic>>> retrieve() async{

    Database db = await database;

    return await db.query('STREAMS');
  }
  Stream<List<Map<String, dynamic>>> retrieveStream() async*{

    Database db = await database;

    yield await db.query('STREAMS');
  }
  void retrieveData() async{
    List<Map<String, dynamic>> list = await retrieve();
    setState(() {
      list.forEach((element) {
        displayList.add(element['name']);
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDB();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            FutureBuilder(
              future: retrieve(),
              builder: (context, snapshot){

                if (snapshot.connectionState == ConnectionState.waiting){

                  return Text('Waiting for data...');
                }else if (snapshot.connectionState == ConnectionState.done){
                 if(snapshot.hasError){

                    return Text('Some error occured!');
                  }
                }
                return Column(
                  children: snapshot.data.map<Widget>((name) => Text('${name['name']}', style: TextStyle(color: Colors.black),)).toList(),
                );
              },
            ),
            StreamBuilder(
              stream: retrieveStream(),
              builder: (context, snapshot){

                if (snapshot.connectionState == ConnectionState.waiting){

                  return Text('Waiting for data...');
                }else if (snapshot.connectionState == ConnectionState.done){
                  if(snapshot.hasError){

                    return Text('Some error occured!');
                  }
                }
                return Column(
                  children: snapshot.data.map<Widget>((name) => Text('${name['name']}', style: TextStyle(color: Colors.black),)).toList(),
                );

              },
            )
          ],
        ),

      ),
    );
  }
}
