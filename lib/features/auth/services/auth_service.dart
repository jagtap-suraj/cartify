import 'dart:convert';
import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/general_response.dart';
import 'package:cartify/models/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Either<String, GeneralResponse<User>>> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      return const Left('No internet connection');
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
      Uri.parse(signUpEndpoint),
      body: user.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      // httpErrorHandlerResponse will be null when status code is 200
      return Right(
        GeneralResponse<User>(
          data: User.fromJson(res.body),
        ),
      );
    }
  }

  Future<Either<String, GeneralResponse<User>>> signInUser({
    required String email,
    required String password,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      return const Left('No internet connection');
    }

    http.Response res = await http.post(
      Uri.parse(signInEndpoint),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      // httpErrorHandlerResponse will be null when status code is 200
      return Right(
        GeneralResponse<User>(
          data: User.fromJson(res.body),
        ),
      );
    }
  }

  Future<Either<String, GeneralResponse<User>>> getUser({
    required String? token,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      //TODO: Implement a way to handle this error
      return const Left('No internet connection');
    }

    if (token == null || token.isEmpty) {
      return const Left('Token is invalid');
    }
    var tokenRes = await http.post(
      Uri.parse(tokenValidationEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    var response = jsonDecode(tokenRes.body);
    if (response == false) {
      return const Left('Token is invalid');
    }
    // get the user data
    http.Response userRes = await http.get(
      Uri.parse(getUserEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: userRes);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      // httpErrorHandlerResponse will be null when status code is 200
      return Right(
        GeneralResponse<User>(
          data: User.fromJson(userRes.body),
        ),
      );
    }
  }
}
