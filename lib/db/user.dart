import 'package:sqflite/sqflite.dart';

// new table
final String userTable = "user";
final String userid_Column = "_id";
final String username_Column = "userid";
final String name_Column = "name";
final String age_Column = "age";
final String password_Column = "password";
final String quote_Column = "quote";

class User {
  int id;
  String username;
  String name;
  String age;
  String password;
  String quote;

  User();

  User.formMap(Map<String, dynamic> map) {
    this.id = map[userid_Column];
    this.username = map[username_Column];
    this.name = map[name_Column];
    this.age = map[age_Column];
    this.password = map[password_Column];
    this.quote = map[quote_Column];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      username_Column: username,
      name_Column: name,
      age_Column: age,
      password_Column: password,
      quote_Column: quote,
    };
    if (id != null) {
      map[userid_Column] = id; 
    }
    return map;
  }

  @override
  String toString() {
    return 'id: ${this.id}, userid: ${this.username}, name: ${this.name}, age: ${this.age}, password: ${this.password}, quote: ${this.quote}';
  }

}

// action in database
class UserData {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $userTable (
        $userid_Column integer primary key autoincrement,
        $username_Column text not null unique,
        $name_Column text not null,
        $age_Column text not null,
        $password_Column text not null,
        $quote_Column text
      )
      ''');
    });
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert(userTable, user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(userTable,
        columns: [userid_Column, username_Column, name_Column, age_Column, password_Column, quote_Column], where: '$userid_Column = ?', whereArgs: [id]);
        maps.length > 0 ? new User.formMap(maps.first) : null;
  }

  Future<int> updateUser(User user) async {
    return db.update(userTable, user.toMap(), where: '$userid_Column = ?', whereArgs: [user.id]);
  }
  
  Future<List<User>> getAllUser() async {
    await this.open("user.db");
    var res = await db.query(userTable, columns: [userid_Column, username_Column, name_Column, age_Column, password_Column, quote_Column]);
    List<User> userList = res.isNotEmpty ? res.map((c) => User.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();

}