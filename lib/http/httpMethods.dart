library httpMethods;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

import '../scannerWithController.dart';

final LocalStorage storage = LocalStorage('floatinityQR');

const Map<String, String> header = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Future<API> httpLogin(x) async {
  final response = await http.post(
      Uri.parse('http://gms.floatinity.com/gms/gauth/login'),
      body: x,
      headers: header);

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    final status = responseBody["status"];
    final errors =
        (responseBody["gmsErrors"] as List).map((e) => e as String).toList();

    String errorString = "";

    if (status == "SUCCESS") {
      final token = response.headers["set-cookies"];
      storage.setItem('token', token);
    } else {
      for (final err in errors) {
        err.split("_").map((value) {
          errorString = "$errorString $value";
        });
      }
    }

    return API(status, errorString);
  } else {
    final status = response.statusCode.toString();
    const error="Unable to load app";
    return API(status, error);
  }
}

class API {
  final String status;
  final String error;

  const API(this.status, this.error);
}
