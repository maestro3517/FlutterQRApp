import 'package:flutter/material.dart';
import 'package:flutter_qr_app/types/login.dart';
import 'package:flutter_qr_app/utils.dart';
import 'Widgets/LoginPassword.dart';
import 'scannerWithController.dart';
import 'Widgets/LoginUsername.dart';
import 'package:localstorage/localstorage.dart';

import 'Widgets/LoginKey.dart';
import 'httpClient.dart';
import 'constants.dart' as constants;

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  final LocalStorage storage = LocalStorage(constants.localStorageKey);

  var error = List.generate(3, (index) => "");
  bool rememberMe = false;

  Future<void> init() async {
    final state = await storage.ready;
    final creds = storage.getItem("creds");
    if (creds != null) {
      setState(() {
        nameController.text = creds["un"];
        passwordController.text = creds["pwd"].toString().toDecrypted();
        loginController.text = creds["loginKey"].toString();
      });
    }
  }

  @override
  void initState() {
    init();
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 100, 10, 0),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30),
                )),
            LoginKey(
                loginController: loginController,
                error: error,
                onChange: (v) {
                  if (error[0].isNotEmpty) {
                    setState(() {
                      error[0] = "";
                    });
                  }
                }),
            UserName(
              error: error,
              onChange: (v) {
                if (error[1].isNotEmpty) {
                  setState(() {
                    error[1] = "";
                  });
                }
              },
              nameController: nameController,
            ),
            Password(
              passwordController: passwordController,
              error: error,
              onChange: (v) {
                if (error[2].isNotEmpty) {
                  setState(() {
                    error[2] = "";
                  });
                }
              },
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    login();
                  },
                ))
          ],
        ));
  }

  Future<void> login() async {
    final key = Encrypt.Key.fromUtf8("ProGMsFLo@tiN!ty");
    final iv = IV.fromUtf8("ProGMsFLo@tiN!ty");
    final encyptedString = Encrypt.Encrypter(
      AES(key, mode: Encrypt.AESMode.ecb, padding: "PKCS7"),
    ).encrypt(passwordController.text, iv: iv);

    final user = User(
        un: nameController.text,
        pwd: encyptedString.base64,
        loginKey: loginController.value as int);
    final x = userToJson(user);

    authenticate(x);
  }
  authenticate(x) async {
    final apiResponse = await httpLogin(x);

    if (apiResponse.error.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const BarcodeScannerWithController()),
      );
      setState(() {
        nameController.clear();
        passwordController.clear();
        passwordController.clear();
      });
    }
    // If the server did not return a 200 OK response,
    // then throw an exception.

    else {
      final errorString = apiResponse.error;
      if (errorString.contains("USER")) {
        setState(() {
          error[1] = errorString;
        });
      } else if (errorString.contains("PASS")) {
        setState(() {
          error[2] = errorString;
        });
      } else {
        setState(() {
          error[0] = errorString;
        });
      }
    }

    return null;
  }
}
