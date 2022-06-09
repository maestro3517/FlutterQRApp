import 'dart:convert';

import 'package:flutter_qr_app/qr.dart';
import 'package:flutter_qr_app/utils.dart';

import 'constants.dart' as constants;

import 'dart:io';

final httpClient = HttpClient();

Future<QrData> getScanData(String qrCode) async {
  final req = await httpClient
      .getUrl(Uri.parse("${constants.baseUrl}gauge/read/qr/?scandata=$qrCode"));

  // req.headers.set("User-Agent", constants.userAgent);

  final res = await req.close();

  final scanData = (await res.transform(utf8.decoder).join()).parseScanData();

  return scanData;
}
