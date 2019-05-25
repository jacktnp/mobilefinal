import 'package:flutter/material.dart';
import './ui/RegisterUI.dart';
import './ui/loginUI.dart';
import './ui/HomepageUI.dart';
import './ui/profileUI.dart';
import './ui/friendPageUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobileFinal2',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginUI(),
        "/register": (context) => RegisterUI(),
        "/home": (context) => HomePage(),
        "/profile": (context) => ProfilePage(),
        "/friend": (context) => FriendPage(),
      },
    );
  }
}
