import 'dart:convert';

import 'package:flutter_qr_app/types/login.dart';
import 'package:flutter_qr_app/types/qr.dart';
import 'package:flutter_qr_app/utils.dart';
import 'package:localstorage/localstorage.dart';

import 'constants.dart' as constants;

import 'dart:io';

final httpClient = HttpClient();
final LocalStorage storage = LocalStorage(constants.localStorageKey);

class LoginResponse {
  final String status;
  final String error;

  const LoginResponse(this.status, this.error);
}

Future<void> setHeaders(HttpClientRequest req,
    [Map<String, String>? headers]) async {
  for (final key in constants.headers.keys) {
    final value = constants.headers[key];
    if (value != null) {
      req.headers.set(key, value);
    }
  }

  if (headers != null) {
    for (final key in headers.keys) {
      final value = headers[key];
      if (value != null) {
        req.headers.set(key, value);
      }
    }
  }
}

Future<LoginResponse> login(LoginData login, bool rememberMe) async {
  final req =
      await httpClient.postUrl(Uri.parse("${constants.baseUrl}/gauth/login"));

  await setHeaders(req);

  req.write(login.toRawJson());
  await req.flush();

  final res = await req.close();

  final loginRes = json.decode(await res.transform(utf8.decoder).join());

  if (res.statusCode == 200) {
    final status = loginRes["status"];
    String errorString = "";
    final errors = loginRes["gmsErrors"] ?? loginRes["globalErrors"];

    if (status == "SUCCESS") {
      final token = res.headers[constants.tokenKey];
      await storage.setItem('token', token);
      await storage.setItem('loginKey', login.loginKey.toString());

      if (rememberMe) {
        await storage.setItem('creds', login);
      }
    } else {
      for (final err in errors) {
        for (final splitError in err.split("_")) {
          errorString = "$errorString $splitError";
        }
      }
    }

    return LoginResponse(status, errorString);
  } else {
    final status = res.statusCode.toString();
    const error = "Unable to load app";
    return LoginResponse(status, error);
  }
}

Future<bool> checkToken(String key) async{
  final loginKey = storage.getItem("loginKey");
  final req = await httpClient.getUrl(Uri.parse(
      "${constants.baseUrl}gauge/read/qr/?scandata=${key}_$loginKey"));

  final token = storage.getItem('token')[0].toString();

  final Map<String, String> headers = {};
  if (token.isNotEmpty && token != "null") {
    headers[constants.tokenKey] = token;
  }

  await setHeaders(req, headers.isEmpty ? null : headers);
  final res = await req.close();

  if(res.statusCode==403){
    return false;
  }

  else {
    return true;
  }
}

Future<QrData> getScanData(String qrCode) async {
  final loginKey = storage.getItem("loginKey");
  final req = await httpClient.getUrl(Uri.parse(
      "${constants.baseUrl}gauge/read/qr/?scandata=${qrCode}_$loginKey"));

  final token = storage.getItem('token')[0].toString();

  final Map<String, String> headers = {};

  if (token.isNotEmpty && token != "null") {
    headers[constants.tokenKey] = token;
  }

  await setHeaders(req, headers.isEmpty ? null : headers);
  final res = await req.close();

  // final x = (await res.transform(utf8.decoder).join());

  final scanData = (await res.transform(utf8.decoder).join()).parseScanData();

  return scanData;
}

void logout() async {
  await storage.deleteItem("token");
  await storage.deleteItem("loginKey");
}
