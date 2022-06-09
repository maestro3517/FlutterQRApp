library utils;

import 'package:flutter_qr_app/qr.dart';


extension Parser on String {
  QrData parseScanData() {
    return QrData.fromRawJson(this);
  }
}