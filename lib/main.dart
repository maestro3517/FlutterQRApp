import 'package:flutter/material.dart';
import 'package:flutter_qr_app/login.dart';
import 'package:flutter_qr_app/constants.dart' as constants;


void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  static const String _title = 'Gauge Management System';
  static const colorCustom = MaterialColor(0xFF985aed, constants.color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch:colorCustom ,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const LoginStatefulWidget(),
      ),
    );
  }

}

