import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart' as flutterKey;
import 'package:flutter_qr_app/Widgets/LoginPassword.dart';
import 'package:flutter_qr_app/types.dart';
import 'package:flutter_qr_app/scannerWithController.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter_qr_app/Widgets/LoginUsername.dart';

import 'Widgets/LoginKey.dart';
import 'http/httpMethods.dart';

class LoginStatefulWidget extends StatefulWidget {
  const LoginStatefulWidget({flutterKey.Key? key}) : super(key: key);

  @override
  State<LoginStatefulWidget> createState() => _LoginStatefulWidgetState();
}

class _LoginStatefulWidgetState extends State<LoginStatefulWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginController = TextEditingController();

  var error = List.generate(3, (index) => "");

  @override
  void initState() {}

  @override
  void dispose() {}

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
                  'Sign in',
                  style: TextStyle(fontSize: 30),
                )),
            LoginKey(
              loginController: loginController,
              error: error,
              onChange: (v) {},
            ),
            UserName(
              nameController: nameController,
              error: error,
              onChange: (v) {},
            ),
            Password(
              passwordController: passwordController,
              error: error,
              onChange: (v) {},
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const BarcodeScannerWithController()),
      );
    } else {
      setState(() {
        errorPassword = "Invalid Username/Password";
      });
    }
  }
}
