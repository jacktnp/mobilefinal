import 'package:flutter/material.dart';
import '../status/onlineUser.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E"),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
            Text('Hello ${CurrentUser.NAME}', style: TextStyle(fontSize: 25.0),),
            Text('this is my quote "${CurrentUser.QUOTE}"', style: TextStyle(fontSize: 16.0, color: Colors.grey),),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentUser.USERID = null;
                CurrentUser.NAME = null;
                CurrentUser.AGE = null;
                CurrentUser.PASSWORD = null;
                CurrentUser.QUOTE = null;
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }

}