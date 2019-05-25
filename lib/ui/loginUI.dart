import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../db/user.dart';
import '../status/onlineUser.dart';


class LoginUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginUIState();
  }

}

class LoginUIState extends State<LoginUI>{
  final _formkey = GlobalKey<FormState>();
  UserData user = UserData();
  final userid = TextEditingController();
  final password = TextEditingController();
  bool isValid = false;
  int formState = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            Image.asset(
              "assets/logo.jpg",
              height: 220,
            ),
            
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User Id",
                  icon: Icon(Icons.person),
                ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isNotEmpty) {
                  this.formState += 1;
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
                icon: Icon(Icons.lock),
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isNotEmpty) {
                  this.formState += 1;
                }
              }
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
            RaisedButton(
              color: Colors.teal,
              textColor: Colors.white,
              splashColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Text("LOGIN"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (userid == userList[i].username && password == userList[i].password){
                      CurrentUser.ID = userList[i].id;
                      CurrentUser.USERID = userList[i].username;
                      CurrentUser.NAME = userList[i].name;
                      CurrentUser.AGE = userList[i].age;
                      CurrentUser.PASSWORD = userList[i].password;
                      CurrentUser.QUOTE = userList[i].quote;
                      this.isValid = true;
                      print("this user valid");
                      break;
                    }
                  }
                }

                if(this.formState != 2){
                  Toast.show(
                    "Please fill out this form",
                    context,
                    duration: Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM
                    );
                  this.formState = 0;
                  //print(111);
                } else {
                  //print(222);
                  this.formState = 0;
                  print("${userid.text}, ${password.text}");
                  await isUserValid(userid.text, password.text);
                  if( !this.isValid){
                    //print(333);
                    Toast.show(
                      "Invalid user or password",
                      context,
                      duration: Toast.LENGTH_SHORT,
                      gravity: Toast.BOTTOM
                    );
                  } else {
                    //print(444);
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }
              },
            ),
            Container(
              child: FlatButton(
                child: Container(
                  child: Text("Register New Account", textAlign: TextAlign.right),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                ),
              alignment: Alignment.bottomRight,
            ),
          ],
        ),
      ),
    );
  }
}