import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cartify/constants/global_variables.dart';

class AuthService {
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check internet connectivity
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      debugPrint('soroaj connectivityResult: $connectivityResult');
      debugPrint('soroaj is empty: ${connectivityResult.isEmpty}');
      if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
        return 'No internet connection';
      }
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );

      debugPrint('soroaj endpoint: $uri/api/signup');
      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint('soroaj response: ${res.body}');
      debugPrint('soroaj response code: ${res.statusCode}');
      final httpErrorHandleResponse = httpErrorHandle(response: res);
      if (httpErrorHandleResponse != null) {
        return httpErrorHandleResponse;
      } else {
        return 'User created successfully';
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }
}
