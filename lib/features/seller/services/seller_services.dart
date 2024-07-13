import 'dart:convert';
import 'dart:io';

import 'package:cartify/constants/api_urls.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/error_handling.dart';
import 'package:cartify/models/product.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class SellerServices {
  Future<Either<String, Product>> addProduct({
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
    required String sellerId,
    required String sellerName,
    required String token,
  }) async {
    final cloudinary = CloudinaryPublic(ApiUrls.cloudName, ApiUrls.uploadPreset);
    List<String> imageUrls = [];

    // Map through the images and upload them to cloudinary
    for (int i = 0; i < images.length; i++) {
      CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          images[i].path,
          folder: '${AppStrings.appTitle}/${sellerName}/${category}/${name}',
        ),
      );
      imageUrls.add(res.secureUrl);
    }

    Product product = Product(
      name: name,
      description: description,
      quantity: quantity,
      images: imageUrls,
      category: category,
      price: price,
      sellerId: sellerId,
    );

    http.Response res = await http.post(
      Uri.parse(ApiUrls.addProductEndpoint),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: product.toJson(),
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

  Future<Either<String, List<Product>>> fetchSellerProducts({
    required String sellerId,
    required String token,
  }) async {
    // Construct the URL with query parameters
    Uri url = Uri.parse(ApiUrls.getSellerProductsEndpoint).replace(queryParameters: {
      'sellerId': sellerId,
    });
    print("sooraj url: $url");
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
