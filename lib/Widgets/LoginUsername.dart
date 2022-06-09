import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginKey extends StatelessWidget {
  const LoginKey({
    Key? key,
    required this.loginController,
    required this.error,
  }) : super(key: key);

  final TextEditingController loginController;
  final List<String> error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: loginController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Login Key',
          errorText: error[2].isEmpty ? null : error[2],
        ),
      ),
    );
  }
}


class UserName extends StatelessWidget {
  const UserName({
    Key? key,
    required this.nameController,
    required this.error,
  }) : super(key: key);

  final TextEditingController nameController;
  final List<String> error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'User Name',
          errorText: error[0].isEmpty ? null : error[0],
        ),
      ),
    );
  }
}

class Password extends StatelessWidget {
  const Password({
    Key? key,
    required this.passwordController,
    required this.error,
  }) : super(key: key);

  final TextEditingController passwordController;
  final List<String> error;

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
          errorText: error[1].isEmpty ? null : error[1],
        ),
      ),
    );
  }
}