

import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class CartServices {
  Future<Either<String, User>> reduceFromCart({
    required String token,
    required Product product,
  }) async {
    Uri url = Uri.parse('${ApiUrls.reduceFromCartEndpoint}/${product.id}');
    http.Response res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      return Right(
        User.fromJson(res.body),
      );
    }
  }

  Future<Either<String, User>> removeFromCart({
    required String token,
    required Product product,
  }) async {
    Uri url = Uri.parse('${ApiUrls.removeFromCartEndpoint}/${product.id}');
    http.Response res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      return Right(
        User.fromJson(res.body),
      );
    }
  }

  Future<Either<String, User>> emptyTheCart({
    required String token,
  }) async {
    Uri url = Uri.parse(ApiUrls.emptyCartEndpoint);
    http.Response res = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      return Right(
        User.fromJson(res.body),
      );
    }
  }
}
