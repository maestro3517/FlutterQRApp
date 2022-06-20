library utils;

import 'package:encrypt/encrypt.dart';
import 'constants.dart';
import 'types/qr.dart';
import '';

extension Parser on String {
  QrData parseScanData() {
    return QrData.fromRawJson(this);
  }
}

extension Encryption on String {
  String toEncrypted() {
    return encrypt(this);
  }
}

extension Decryption on String {
  String toDecrypted() {
    return decrypt(this);
  }
}

String encrypt(String password) {
   final encyptedString = Encrypter(
    AES(aesKey, mode: AESMode.ecb, padding: "PKCS7"),
  ).encrypt(password, iv: iv);
  return encyptedString.base64;
}

String decrypt(String password) {
  final decyptedString = Encrypter(
    AES(aesKey, mode: AESMode.ecb, padding: "PKCS7"),
  ).decrypt(Encrypted.fromBase64(password), iv: iv);
  return decyptedString;
}
