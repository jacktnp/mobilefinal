import 'package:flutter/material.dart';

import '../status/onlineUser.dart';
import '../db/user.dart';


class ProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }

}

class ProfilePageState extends State<ProfilePage>{
  final _formkey = GlobalKey<FormState>();

  UserData user = UserData();
  final userid = TextEditingController(text: CurrentUser.USERID);
  final name = TextEditingController(text: CurrentUser.NAME);
  final age = TextEditingController(text: CurrentUser.AGE);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentUser.QUOTE);

  bool isUserIn = false;

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  int countSpace(String s){
    int result = 0;
    for(int i = 0;i<s.length;i++){
      if(s[i] == ' '){
        result += 1;
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
                icon: Icon(Icons.person),
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if (isUserIn){
                  return "This Username is taken";
                }
                else if (value.length < 6 || value.length > 12){
                  return "User Id must be between 6 to 12";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
                icon: Icon(Icons.account_circle),
              ),
              controller: name,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if(countSpace(value) != 1){
                  return "Please fill Name Correctly";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
                icon: Icon(Icons.event_note),
              ),
              controller: age,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill Age";
                }
                else if (!isNumeric(value) || int.parse(value) < 10 || int.parse(value) > 80) {
                  return "Please fill Age Between 10 to 80";
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
                if (value.isEmpty || value.length <= 6) {
                  return "Password must be longer than 6";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Quote",
                icon: Icon(Icons.add_comment),
              ),
              controller: quote,
              keyboardType: TextInputType.text,
              maxLines: 3
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              color: Colors.teal,
              textColor: Colors.white,
              splashColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Text("SAVE"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                userData.id = CurrentUser.ID;
                userData.username = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;
                userData.quote = quote.text;
                //function to check if user in
                Future isUserTaken(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (user.username == userList[i].username && CurrentUser.ID != userList[i].id){
                      print('Taken');
                      this.isUserIn = true;
                      break;
                    }
                  }
                }
                //validate form
                if (_formkey.currentState.validate()){
                  await isUserTaken(userData);
                  print(this.isUserIn);
                  //if user not exist
                  if(!this.isUserIn) {
                    await user.updateUser(userData);
                    CurrentUser.USERID = userData.username;
                    CurrentUser.NAME = userData.name;
                    CurrentUser.AGE = userData.age;
                    CurrentUser.PASSWORD = userData.password;
                    CurrentUser.QUOTE = userData.quote;
                    Navigator.pop(context);
                    print('insert complete');
                  }
                }

                this.isUserIn = false;

              }
            ),
          ]
        ),
      )
    );
  }

}