import 'dart:convert';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final storage = const FlutterSecureStorage();
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check internet connectivity
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
        return 'No internet connection';
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: jsonEncode({
          'email': email,
          'password': password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final httpErrorHandleResponse = httpErrorHandle(response: res);
      if (httpErrorHandleResponse == null) {
        return 'User created successfully';
      } else {
        return httpErrorHandleResponse;
      }
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  Future<String> signInUser({
    required String email,
    required String password,
    required Function(String) onTokenReceived, // A callback to store token in secure storage and user in provider
  }) async {
    try {
      // Check internet connectivity
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
        return 'No internet connection';
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final httpErrorHandleResponse = httpErrorHandle(response: res);
      if (httpErrorHandleResponse == null) {
        onTokenReceived(res.body);
        await storage.write(key: 'x-auth-token', value: jsonDecode(res.body)['token']);

        return 'logged in successfully';
      } else {
        return httpErrorHandleResponse;
      }
    } catch (e) {
      return 'An error occured. Please try again later';
    }
  }
}
