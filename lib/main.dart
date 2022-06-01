import 'package:flutter/material.dart';
import 'package:flutter_qr_app/login.dart';
import 'package:flutter_qr_app/constants.dart' as constants;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        body: const MyStatefulWidget(),
      ),
    );
  }


}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MyStatefulWidget()
      );
  }
}

