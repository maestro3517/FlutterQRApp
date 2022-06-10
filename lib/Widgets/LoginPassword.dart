import 'package:flutter/material.dart';
import 'package:flutter_qr_app/constants.dart' as constants;

class Password extends StatefulWidget {
  final TextEditingController passwordController;
  final List<String> error;

  final Function(String) onChange;

  Password(
      {Key? key,
      required this.passwordController,
      required this.error,
      required this.onChange})
      : super(key: key) {
    passwordController.addListener(() {
      onChange(passwordController.value.text);
    });
  }

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  initState() {}

  var passwordVisible = true;

  static const colorCustom = MaterialColor(0xFF985aed, constants.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: TextField(
        obscureText: passwordVisible,
        controller: widget.passwordController,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.black,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(color: colorCustom),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: const BorderSide(width: 1, color: Colors.black),
            ),
            border: const OutlineInputBorder(),
            labelText: 'Password',
            errorText: widget.error[2].isEmpty ? null : widget.error[2],
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState((){
                  passwordVisible = !passwordVisible;
                });
              },
            )),
      ),
    );
  }
}
