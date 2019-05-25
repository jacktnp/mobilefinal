import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../db/friend.dart';

class FriendPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

class FriendPageState extends State<FriendPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: RaisedButton(
                color: Colors.teal,
                textColor: Colors.white,
                splashColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                child: Text("BACK"),
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/home');
                },
              ),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
            ),
            FutureBuilder(
              future: pullUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Friend> values = snapshot.data;
    return Expanded(
      child: ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.fromLTRB(30, 5, 30, 10),
            child: InkWell(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${(values[index].id).toString()} : ${values[index].name}\n",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      values[index].email,
                    ),
                    Text(
                      values[index].phone,
                    ),
                    Text(
                      values[index].website,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

