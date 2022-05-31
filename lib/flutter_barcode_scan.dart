import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBarcodeScan {
  static const CameraAccessDenied = 'PERMISSION_NOT_GRANTED';
  static const UserCanceled = 'USER_CANCELED';

  static const MethodChannel _channel = MethodChannel('flutter_barcode_scan');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> scan() async => await _channel.invokeMethod('scan');
}