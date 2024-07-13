import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;
  final int maxLines;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.maxLines = 1, // For Product Description
      this.textInputType = TextInputType.text});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.textInputType == TextInputType.visiblePassword;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.textInputType == TextInputType.visiblePassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: _togglePasswordVisibility,
              )
            : null,
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
      keyboardType: widget.textInputType,
      obscureText: _obscureText,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return widget.hintText;
        }
        if (widget.textInputType == TextInputType.emailAddress && !emailRegex.hasMatch(val)) {
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