import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isEmail;

  const CustomTextField({super.key, required this.controller, required this.labelText, required this.hintText, this.isEmail = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return hintText;
        }
        if (isEmail && !emailRegex.hasMatch(val)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }
}

/**
 * We used TextFormField instead of TextField because it has validator that is used to
 * make validations and if any error is found, it will be called by the form and it
 * will throw the error message on the screen.
 */