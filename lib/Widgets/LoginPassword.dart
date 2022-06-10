import 'package:flutter/material.dart';

class Password extends StatelessWidget {
  Password(
      {Key? key,
      required this.error,
      required this.onChange,
      required this.passwordController})
      : super(key: key) {
    passwordController.addListener(() {
      onChange(passwordController.value.text);
      if (error[2].isNotEmpty) {
        error[2] = "";
      }
    });
  }

  final TextEditingController passwordController;
  final List<String> error;

  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
      child: TextField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Password',
          errorText: error[2].isEmpty ? null : error[2],
        ),
      ),
    );
  }
}
