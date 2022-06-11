import 'package:flutter/material.dart';
import 'package:flutter_qr_app/constants.dart' as constants;

class LoginKey extends StatelessWidget {
  final Function(String) onChange;

  final TextEditingController loginController;
  final List<String> error;
  static const colorCustom = MaterialColor(0xFF985aed, constants.color);


  LoginKey({
    Key? key,
    required this.loginController,
    required this.error,
    required this.onChange,
  }) : super(key: key) {
    loginController.addListener(() {
      onChange(loginController.value.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: loginController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.numbers,
            color: Colors.black,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color:colorCustom),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(width: 1, color: Colors.black),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Login Key',
          errorText: error[0].isEmpty ? null : error[0],
        ),
      ),
    );
  }
}
