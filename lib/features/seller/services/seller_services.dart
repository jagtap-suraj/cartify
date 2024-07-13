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
}
