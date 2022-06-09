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

Future<void> setHeaders(HttpClientRequest req) async {
  for (final key in constants.headers.keys) {
    if (constants.headers.containsValue(key)) {
      final value = constants.headers[key];
      req.headers.set(key, value!);
    }
  }
}

Future<LoginResponse> login(LoginData login) async {

  final req = await httpClient
      .postUrl(Uri.parse("${constants.baseUrl}gauge/gms/gauth/login"));

  await setHeaders(req);

  req.write(login);
  await req.flush();

  final res = await req.close();

  final loginRes = json.decode(await res.transform(utf8.decoder).join());

  if (res.statusCode == 200) {
    final status = loginRes["status"];
    final errors =
    (loginRes["gmsErrors"] as List).map((e) => e as String).toList();

    String errorString = "";

    if (status == "SUCCESS") {
      final token = res.headers[constants.tokenKey];
      storage.setItem('token', token);
    } else {
      for (final err in errors) {
        err.split("_").map((value) {
          errorString = "$errorString $value";
        });
      }
    }

    return LoginResponse(status, errorString);
  } else {
    final status = res.statusCode.toString();
    const error="Unable to load app";
    return LoginResponse(status, error);
  }
}

Future<QrData> getScanData(String qrCode) async {
  final req = await httpClient
      .getUrl(Uri.parse("${constants.baseUrl}gauge/read/qr/?scandata=$qrCode"));

  await setHeaders(req);
  // req.headers.set("User-Agent", constants.userAgent);

  final res = await req.close();

  final scanData = (await res.transform(utf8.decoder).join()).parseScanData();

  return scanData;
}
