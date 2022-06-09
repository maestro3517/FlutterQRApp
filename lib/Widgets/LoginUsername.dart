import 'package:flutter/material.dart';

class UserName extends StatelessWidget {
  UserName({
    Key? key,
    required this.error,
    required this.onChange, required this.nameController
  }) : super(key: key){
    nameController.addListener(() {
      onChange(nameController.value.text);
      if (error[1].isNotEmpty) {
        error[1]="";
      }
    });
  }

  final TextEditingController nameController;
  final List<String> error;

  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'User Name',
          errorText: error[1].isEmpty ? null : error[1],
        ),
      ),
    );
  }


}

