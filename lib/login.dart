import 'package:flutter/material.dart';
import 'package:flutter_qr_app/types.dart';
import 'package:flutter_qr_app/scannerWithController.dart';
import 'package:localstorage/localstorage.dart';

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  final LocalStorage storage = LocalStorage('floatinityQR');
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorPassword = "";
  String errorUsername = "";

  @override
  void initState() {
    passwordController.addListener(() {
      if (errorPassword.isNotEmpty) {
        setState(() {
          errorPassword = "";
        });
      }
    });
    nameController.addListener(() {
      if (errorUsername.isNotEmpty) {
        setState(() {
          errorUsername = "";
        });
      }
    });
  }

  @override
  void dispose(){
    passwordController.removeListener(() { });
    nameController.removeListener(() { });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                  errorText: errorUsername.isEmpty ? null : errorUsername,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  errorText: errorPassword.isEmpty ? null : errorPassword,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                    login();
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ));
  }

  void login() {
    final user = User(
        un: nameController.value.text,
        pwd: passwordController.value.text,
        loginKey: 123);
    final x = userToJson(user);

    if (user.un == "pooja@floatinity.com" &&
        user.pwd == "YQeaI7frUFfcaFMkakLizw==") {
      const token = "xyz";
      storage.setItem('token', token);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const BarcodeScannerWithController()),
      );
    } else {
      setState(() {
        errorPassword = "Invalid Username/Password";
        errorUsername = "Invalid Username/Password";
      });
    }
  }
}
