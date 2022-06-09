import 'dart:convert';

import 'package:flutter_qr_app/qr.dart';
import 'package:flutter_qr_app/utils.dart';

import 'constants.dart' as constants;

import 'dart:io';

final httpClient = HttpClient();

Future<void> setHeaders(HttpClientRequest req) async {
  for (final key in constants.headers.keys) {
    if (constants.headers.containsValue(key)) {
      final value = constants.headers[key];
      req.headers.set(key, value!);
    }
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
