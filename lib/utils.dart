library utils;

import 'package:flutter_qr_app/types/qr.dart';


extension Parser on String {
  QrData parseScanData() {
    return QrData.fromRawJson(this);
  }
}