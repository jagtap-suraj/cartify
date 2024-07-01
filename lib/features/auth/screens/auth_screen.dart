// ignore_for_file: use_build_context_synchronously

import 'package:cartify/common/custom_button.dart';
import 'package:cartify/common/custom_textfield.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum AuthType {
  signIn,
  signUp
}

class AuthScreen extends StatefulWidget {
  static const String routeName = "/auth-screen";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType _authType = AuthType.signUp;
  final AuthService authService = AuthService();

  /// A global key used to uniquely identify the respective widget.
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  /// Controllers are used to manage and interact with the text input in TextField widgets,
  /// allowing for reading and updating the input value, and listening for changes.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void signUpUser() async {
    if (_signUpFormKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      // Capture the context before the async gap
      var localContext = context;
      try {
        final value = await authService.signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
        showToast(value);
        // Use the captured context after the async operation
        if (!mounted) return;
        Navigator.pop(localContext); // Close the progress dialog
        showToast(value);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(localContext); // Close the progress dialog
        showToast('An error occurred. Please try again.');
      }
    }
  }

  @override
  void dispose() {
    /// We need to dispose the controllers to free up the resources.
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ListTile(
                  tileColor: _authType == AuthType.signUp ? GlobalVariables.backgroundColor : null,
                  title: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 18),
                  ),
                  leading: Radio(
                      value: AuthType.signUp,
                      groupValue: _authType,
                      onChanged: (value) {
                        setState(() {
                          _authType = value as AuthType;
                        });
                      }),
                ),
                if (_authType == AuthType.signUp)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nameController,
                            hintText: "Enter your name",
                            labelText: "Name",
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _emailController,
                            hintText: "Enter your email",
                            labelText: "Email",
                            isEmail: true,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: "Enter your password",
                            labelText: "Password",
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            text: "Sign Up",
                            onTap: () {
                              signUpUser();
                            },
                            color: GlobalVariables.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _authType == AuthType.signIn ? GlobalVariables.backgroundColor : null,
                  title: const Text("Sign-In"),
                  leading: Radio(
                      value: AuthType.signIn,
                      groupValue: _authType,
                      onChanged: (value) {
                        setState(() {
                          _authType = value as AuthType;
                        });
                      }),
                ),
                if (_authType == AuthType.signIn)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            hintText: 'Enter your email',
                            labelText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hintText: 'Enter your password',
                            labelText: 'Password',
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            color: GlobalVariables.secondaryColor,
                            text: 'Sign In',
                            onTap: () {
                              //TODO: Perfom Validation using signInFormKey
                            },
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
