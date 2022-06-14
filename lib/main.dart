import 'package:flutter/material.dart';
import 'package:flutter_qr_app/login.dart';
import 'package:flutter_qr_app/constants.dart' as constants;
import 'package:flutter_qr_app/widgets/SplashScreen.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  static const colorCustom = MaterialColor(0xFF985aed, constants.color);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginWrapper(),
      },
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
    );
  }
}

class LoginWrapper extends StatelessWidget {
  const LoginWrapper({Key? key}) : super(key: key);
  static const String _title = 'Gauge Management System';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const LoginStatefulWidget(),
    );
  }
}
