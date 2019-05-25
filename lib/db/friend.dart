import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Friend>> pullUser() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<Friend> userJson = [];

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    for(int i = 0; i< data.length;i++){
      var user = Friend.fromJson(data[i]);
      userJson.add(user);
    }
    return userJson;

  }
  else {
    throw Exception('Failed to load post');
  }
}

class Friend {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  Friend({this.id, this.name, this.email, this.phone, this.website});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}
