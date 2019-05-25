import 'package:flutter/material.dart';

import '../db/user.dart';


class RegisterUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterUIState();
  }

}

class RegisterUIState extends State<RegisterUI>{
  final _formkey = GlobalKey<FormState>();

  UserData user = UserData();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final quote = TextEditingController();

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
        title: Text("Register"),
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
                else if (value.length < 6 || value.length > 12){
                  return "Please fill User Id be between 6 to 12";
                }
                else if (this.isUserIn){
                  return "This Username is taken";
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
                if(countSpace(value) != 1){
                  return "Please have space between first and last name";
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
                if (value.isEmpty) {
                  return "Please fill Age";
                }
                else if (value.length <= 6) {
                  return "Password must be longer than 6";
                }
              }
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              color: Colors.teal,
              textColor: Colors.white,
              splashColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Text("REGISTER NEW ACCOUNT"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                userData.username = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;

                //function to check if user in
                Future isNewUserIn(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (user.username == userList[i].username){
                      this.isUserIn = true;
                      break;
                    }
                  }
                }

                await isNewUserIn(userData);
                print(this.isUserIn);

                if (_formkey.currentState.validate()){
                  if(await !this.isUserIn) {
                    userid.text = "";
                    name.text = "";
                    age.text = "";
                    password.text = "";
                    await user.insertUser(userData);
                    Navigator.pop(context);
                    print('insert success');
                  }
                }

                this.isUserIn = false;
              }
              
            ),
          ],
        ),
      ),
    );
  }
}