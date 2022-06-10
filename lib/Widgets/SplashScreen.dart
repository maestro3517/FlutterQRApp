import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:localstorage/localstorage.dart';

class SplashScreenWidget extends StatelessWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalStorage storage = LocalStorage("flutterQR.json");

  @override
  void initState() {
    super.initState();
  }

  nextScreen() {
    Timer(const Duration(seconds: 3), () {
      if (storage.getItem("token") != null) {
        // () => Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => const QRApp()));
        return QRApp();
      } else {
        // () => Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const LoginStatefulWidget()));
        return LoginStatefulWidget();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.purple));
  }
}
