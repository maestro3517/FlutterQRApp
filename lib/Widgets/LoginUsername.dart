import 'package:flutter/material.dart';
import 'package:flutter_qr_app/constants.dart' as constants;

class UserName extends StatelessWidget {

  final TextEditingController nameController;
  final List<String> error;

  final Function(String) onChange;
  static const colorCustom = MaterialColor(0xFF985aed, constants.color);


  UserName({
    Key? key,
    required this.error,
    required this.onChange,
    required this.nameController
  }) : super(key: key){
    nameController.addListener(() {
      onChange(nameController.value.text);
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
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
          labelText: 'User Name',
          errorText: error[1].isEmpty ? null : error[1],
        ),
      ),
    );
  }


}

