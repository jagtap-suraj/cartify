import 'dart:convert';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/models/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
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

      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
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
        const storage = FlutterSecureStorage();
        await storage.write(key: 'x-auth-token', value: jsonDecode(res.body)['token']);

        return 'logged in successfully';
      } else {
        return httpErrorHandleResponse;
      }
    } catch (e) {
      return 'An error occured. Please try again later';
    }
  }

  // Get user data
  Future<String> getUserData({
    // a callback to store user data in provider
    required Function(String) onUserDataReceived,
  }) async {
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      if (token == null) {
        await storage.write(key: 'x-auth-token', value: '');
        return 'Token not found';
      }
      var tokenRes = await http.post(Uri.parse('$uri/api/istokenvalid'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      var response = jsonDecode(tokenRes.body);
      if (response == false) {
        return 'Token is invalid';
      }
      // get the user data
      http.Response userRes = await http.get(Uri.parse('$uri/'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      final httpErrorHandleResponse = httpErrorHandle(response: userRes);
      if (httpErrorHandleResponse == null) {
        onUserDataReceived(userRes.body);
        return 'User data received successfully';
      } else {
        return httpErrorHandleResponse;
      }
    } catch (e) {
      return 'An error occured. Please try again later';
    }
  }
}
