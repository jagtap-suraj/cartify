import 'dart:convert';

import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/user.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<Either<String, User>> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      return const Left(AppStrings.noInternetConnection);
    }

    User user = User(
      name: name,
      password: password,
      email: email,
    );

    http.Response res = await http.post(
      Uri.parse(ApiUrls.signUpEndpoint),
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
        User.fromJson(res.body),
      );
    }
  }

  Future<Either<String, User>> signInUser({
    required String email,
    required String password,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      return const Left(AppStrings.noInternetConnection);
    }

    http.Response res = await http.post(
      Uri.parse(ApiUrls.signInEndpoint),
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
        User.fromJson(res.body),
      );
    }
  }

  Future<Either<String, User>> getUser({
    required String? token,
  }) async {
    // Check internet connectivity
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.isEmpty || connectivityResult[0] == ConnectivityResult.none) {
      //TODO: Implement a way to handle this error
      return const Left(AppStrings.noInternetConnection);
    }

    if (token == null || token.isEmpty) {
      return const Left(AppStrings.tokenIsInvalid);
    }
    var tokenRes = await http.post(
      Uri.parse(ApiUrls.tokenValidationEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    var response = jsonDecode(tokenRes.body);
    if (response == false) {
      return const Left(AppStrings.tokenIsInvalid);
    }
    // get the user data
    http.Response userRes = await http.get(
      Uri.parse(ApiUrls.getUserEndpoint),
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
        User.fromJson(userRes.body),
      );
    }
  }
}
