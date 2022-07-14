import 'package:flutter/material.dart';
import 'package:flutter_qr_app/widgets/LandingPage.dart';

import 'package:flutter_qr_app/widgets/LoginPassword.dart';
import 'package:flutter_qr_app/widgets/LoginUsername.dart';
import 'package:flutter_qr_app/types/login.dart';

import 'package:flutter_qr_app/utils.dart';
import 'widgets/LoginPassword.dart';
import 'widgets/LoginUsername.dart';
import 'package:localstorage/localstorage.dart';

import 'widgets/LoginKey.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Container(
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
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Checkbox(
                      value: rememberMe,
                      onChanged: (final value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      }),
                  const Text('Remember Me', style: TextStyle(fontSize: 15.0))
                ]),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      child: const Text('Sign In',
                          style: TextStyle(fontSize: 20.0)),
                      onPressed: () {
                        onSubmit();
                      },
                    ))
              ],
            )));
  }

  Future<void> onSubmit() async {
    try {
      validateForm();

      final user = LoginData(
          un: nameController.text,
          pwd: passwordController.text.toEncrypted(),
          loginKey: int.parse(loginController.value.text));
      // final loginData = userToJson(user);

      authenticate(user);
    } catch (e) {}
  }

  authenticate(LoginData loginData) async {
    final apiResponse = await login(loginData, rememberMe);

    //


    if (apiResponse.error.isEmpty) {

      //get UserName from Email
      final userName = nameController.text.split("@")[0];
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingPage(userId: userName)),
      );
      setState(() {
        nameController.clear();
        passwordController.clear();
        loginController.clear();
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
  }

  validateForm() {
    const errorString = "Please Enter the required field info";
    if (passwordController.value.text.isEmpty) {
      setState(() {
        error[2] = errorString;
      });
    }
    if (nameController.value.text.isEmpty) {
      setState(() {
        error[1] = errorString;
      });
    }
    if (loginController.value.text.isEmpty) {
      setState(() {
        error[0] = errorString;
      });
    }
  }
}
