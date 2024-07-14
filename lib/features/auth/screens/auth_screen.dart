import 'dart:convert';

import 'package:cartify/common/widgets/custom_button.dart';
import 'package:cartify/common/widgets/custom_textfield.dart';
import 'package:cartify/common/widgets/loader.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/models/user.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum AuthType {
  signIn,
  signUp
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false; // A loader to show while fetching user data
  String? selectedUserType;
  bool _isValidUserType = false;
  AuthType _authType = AuthType.signUp;
  final AuthService authService = AuthService();
  final storage = const FlutterSecureStorage();

  /// A global key used to uniquely identify the respective widget.
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  /// Controllers are used to manage and interact with the text input in TextField widgets,
  /// allowing for reading and updating the input value, and listening for changes.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _validatedUserType() {
    if (selectedUserType == null) {
      setState(() {
        _isValidUserType = false; // Update the variable based on category selection
      });
      showSnackBar(context, 'Please select a category.'); // Optionally show a snackbar message
      return false;
    } else {
      setState(() {
        _isValidUserType = true;
      });
      return true;
    }
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void signUpUser() async {
    if (_signUpFormKey.currentState!.validate() && _validatedUserType()) {
      _toggleLoading(); // Start loading
      try {
        final signUpResult = await authService.signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          type: selectedUserType!,
        );
        if (!mounted) return;
        signUpResult.fold(
          (left) => {
            showSnackBar(context, left),
          },
          (right) {
            showSnackBar(context, AppStrings.userSignUpSuccess);
          },
        );
      } catch (e) {
        if (!mounted) return;
        showSnackBar(context, 'An error occurred. Please try again.');
      } finally {
        _toggleLoading();
      }
    }
  }


  Future<void> signInUser() async {
    if (_signInFormKey.currentState!.validate()) {
      _toggleLoading();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        final signInResult = await authService.signInUser(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (!mounted) return;
        signInResult.fold(
          (left) => {
            showSnackBar(context, left),
          },
          (right) async {
            showSnackBar(context, AppStrings.userSignInSuccess);
            storage.write(key: 'x-auth-token', value: right.token);
            userProvider.setUser(right);
            if (!mounted) return;
            if (userProvider.user.type == 'admin' || userProvider.user.type == 'seller') {
              context.goNamed(AppRoute.sellerScreen.name);
            } else {
              context.goNamed(AppRoute.customBottomNavigationBar.name);
            }
          },
        );
      } catch (e) {
        if (!mounted) return;
        showSnackBar(context, AppStrings.genericErrorMessage);
      } finally {
        _toggleLoading(); // Stop loading
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
            child: _isLoading
                ? const Loader()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.welcomeMessage,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ListTile(
                          tileColor: _authType == AuthType.signUp ? GlobalVariables.backgroundColor : null,
                          title: const Text(
                            AppStrings.createAccount,
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
                                    hintText: AppStrings.enterYourName,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: _emailController,
                                    hintText: AppStrings.enterYourEmail,
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: _passwordController,
                                    hintText: AppStrings.enterYourPassword,
                                    textInputType: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 10),
                                  // user type dropdown
                                  SizedBox(
                                    width: double.infinity,
                                    child: DropdownButton<String>(
                                      value: selectedUserType,
                                      hint: const Text(AppStrings.selectUserType),
                                      padding: const EdgeInsets.only(right: 10),
                                      icon: const Icon(Icons.keyboard_arrow_down),
                                      items: GlobalVariables.userTypes.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedUserType = value;
                                          _isValidUserType = true;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CustomButton(
                                    text: AppStrings.signUp,
                                    onTap: () {
                                      signUpUser();
                                    },
                                    color: GlobalVariables.floatingActionButtonColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ListTile(
                          tileColor: _authType == AuthType.signIn ? GlobalVariables.backgroundColor : null,
                          title: const Text(AppStrings.signIn),
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
                                    hintText: AppStrings.enterYourEmail,
                                    textInputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextField(
                                    controller: _passwordController,
                                    hintText: AppStrings.enterYourPassword,
                                    textInputType: TextInputType.visiblePassword,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomButton(
                                    color: GlobalVariables.floatingActionButtonColor,
                                    text: AppStrings.signIn,
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
          ),
        ));
  }
}
