library types;

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.un,
    required this.pwd,
    required this.loginKey,
  });

  String un;
  String pwd;
  int loginKey;

  factory User.fromJson(Map<String, dynamic> json) => User(
    un: json["un"],
    pwd: json["pwd"],
    loginKey: json["loginKey"],
  );

  Map<String, dynamic> toJson() => {
    "un": un,
    "pwd": pwd,
    "loginKey": loginKey,
  };
}
