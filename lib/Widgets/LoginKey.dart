import 'package:flutter/material.dart';

class LoginKey extends StatelessWidget {

  LoginKey({
    required this.loginController,
    Key? key,
    required this.error,
    required this.onChange
  }) : super(key: key){
    loginController.addListener(() {
      onChange(loginController.value.text);
      if (error[0].isNotEmpty) {
        error[0]="";
      }
    });
  }

  final Function(String) onChange;


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
          errorText: this.error[0].isEmpty ? null : error[0],

        ),
      ),
    );
  }
}