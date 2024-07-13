import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isEmail;
  final bool obscureText; // To hide the password
  final Widget? suffixIcon;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isEmail = false,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1, // For Product Description
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: suffixIcon,
        // Other decoration properties
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
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      obscureText: obscureText,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return hintText;
        }
        if (isEmail && !emailRegex.hasMatch(val)) {
          return AppStrings.enterAValidEmailAddress;
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