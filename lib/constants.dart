library flutter_qr_app.constants;

import 'dart:ui';
import 'package:encrypt/encrypt.dart';

const baseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');

const localStorageKey = "floatinityQR.json";

const tokenKey = "gtk";

const headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

const color = {
  50: Color.fromRGBO(152, 90, 237, .1),
  100: Color.fromRGBO(152, 90, 237, .2),
  200: Color.fromRGBO(152, 90, 237, .3),
  300: Color.fromRGBO(152, 90, 237, .4),
  400: Color.fromRGBO(152, 90, 237, .5),
  500: Color.fromRGBO(152, 90, 237, .6),
  600: Color.fromRGBO(152, 90, 237, .7),
  700: Color.fromRGBO(152, 90, 237, .8),
  800: Color.fromRGBO(152, 90, 237, .9),
  900: Color.fromRGBO(152, 90, 237, 1),
};

const key=String.fromEnvironment('KEY', defaultValue: '');

Key aesKey = Key.fromUtf8(key);
IV iv = IV.fromUtf8(key);
