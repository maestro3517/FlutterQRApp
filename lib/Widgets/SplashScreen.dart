import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_app/httpClient.dart';
import 'package:flutter_qr_app/widgets/WAQrScannerScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:localstorage/localstorage.dart';

import '../constants.dart' as constants;
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage(constants.localStorageKey);
  static const colorCustom = MaterialColor(0xFF985aed, constants.color);
  bool status = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> check() async {
    final statusCode = await checkToken("1");
    return statusCode;
  }

  Widget nextScreen() {
    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        final token = storage.getItem('token');

        if (token != null) {
          return FutureBuilder(
            future: check(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return WAQrScannerScreen();
            },
          );
        } else {
          return const LoginWrapper();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: colorCustom,
      ),
      home: AnimatedSplashScreen(
          duration: 1000,
          splash: const SizedBox(
            height: 100,
            child: Text("GMS",
                style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          nextScreen: nextScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.rightToLeft,
          backgroundColor: colorCustom),
    );
  }
}
