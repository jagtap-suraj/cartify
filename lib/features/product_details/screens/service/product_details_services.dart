import 'dart:convert';

import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/models/user.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices {
  Future<Either<String, User>> addToCart({
    required String token,
    required Product product,
  }) async {
    print("url URI.parse(ApiUrls.addToCartEndpoint): ${Uri.parse(ApiUrls.addToCartEndpoint)}");
    http.Response res = await http.post(
      Uri.parse(ApiUrls.addToCartEndpoint),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode(
        {
          'productId': product.id,
        },
      ),
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      print("sooraj User.fromJson(res.body): ${User.fromJson(res.body)}");
      return Right(
        User.fromJson(res.body),
      );
    }
  }

  Future<Either<String, Product>> rateProduct({
    required String token,
    required String productId,
    required double rating,
  }) async {
    // Construct the URL with query parameters
    // /api/products/:productId/rating
    Uri url = Uri.parse('${ApiUrls.productsEndpoint}/$productId/rating');

    http.Response res = await http.post(
      url, // Use the modified URL with query parameters
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode(
        {
          'rating': rating
        },
      ),
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      return Right(
        Product.fromJson(res.body),
      );
    }
  }
}
