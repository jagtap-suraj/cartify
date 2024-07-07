import 'dart:convert';

import 'package:cartify/common/custom_button.dart';
import 'package:cartify/common/custom_textfield.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/auth/screens/home_screen.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

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
  bool _isPasswordVisible = false;
  final storage = const FlutterSecureStorage();

  /// A global key used to uniquely identify the respective widget.
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  /// Controllers are used to manage and interact with the text input in TextField widgets,
  /// allowing for reading and updating the input value, and listening for changes.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void signUpUser() async {
    if (_signUpFormKey.currentState!.validate()) {
      // Show dialog while the user is being signed up
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final value = await authService.signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        );
        if (!mounted) return;
        Navigator.pop(context); // Close the progress dialog
        showSnackBar(context, value);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close the progress dialog
        showSnackBar(context, 'An error occurred. Please try again.');
      }
    }
  }

  void signInUser() async {
    if (_signInFormKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final userProvider = Provider.of<UserProvider>(context, listen: false);

      try {
        final value = await authService.signInUser(
          email: _emailController.text,
          password: _passwordController.text,
          onTokenReceived: (responseBody) async {
            await storage.write(key: 'x-auth-token', value: jsonDecode(responseBody)['token']);
            userProvider.setUser(responseBody);
          },
        );

        if (!mounted) return;
        // Ensure the dialog is closed before navigating
        Navigator.pop(context); // Close the progress dialog
        showSnackBar(context, value);
        // Navigate to the HomeScreen
        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Ensure the dialog is closed even in case of an error
        showSnackBar(context, 'An error occurred. Please try again.');
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
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
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
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            color: GlobalVariables.secondaryColor,
                            text: 'Sign In',
                            onTap: () {
                              signInUser();
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
