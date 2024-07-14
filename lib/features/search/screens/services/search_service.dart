import 'dart:convert';

import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/product.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class SearchService {
  Future<Either<String, List<Product>>> fetchSearchedProducts({
    required String token,
    required String searchQuery,
  }) async {
    // Construct the URL with query parameters
    Uri url = Uri.parse(ApiUrls.productsEndpoint).replace(queryParameters: {
      'search': searchQuery,
    });
    http.Response res = await http.get(
      url, // Use the modified URL with query parameters
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );
    String? httpErrorHandlerResponse = httpErrorHandler(response: res);
    if (httpErrorHandlerResponse != null) {
      return Left(httpErrorHandlerResponse);
    } else {
      List<Product> productList = [];

      /// The response body is first converted to a map using which we will
      /// be able to get a particular product's json since we are looping over it
      /// and then we are encoding that since fromJson accepts a string source
      /// and then we are converting that to a Product object and adding it to the list.
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        productList.add(
          Product.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }
      return Right(productList);
    }
  }
}
