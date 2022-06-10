import 'package:meta/meta.dart';
import 'dart:convert';

class LoginData {
  LoginData({
    required this.un,
    required this.pwd,
    required this.loginKey,
  });

  String un;
  String pwd;
  int loginKey;

  factory LoginData.fromRawJson(String str) => LoginData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
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
