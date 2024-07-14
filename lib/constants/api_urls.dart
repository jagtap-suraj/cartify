import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  // Base host and port
  static String baseHost = dotenv.env['HOST']!;
  static String basePort = dotenv.env['PORT']!;

  // Complete base URI
  static String baseUri = 'http://$baseHost:$basePort';
  static String apiBaseUri = '$baseUri/api';

  // Authentication API endpoints
  static String signInEndpoint = '$apiBaseUri/signin';
  static String signUpEndpoint = '$apiBaseUri/signup';
  static String getUserEndpoint = '$apiBaseUri/user';
  static String tokenValidationEndpoint = '$apiBaseUri/istokenvalid';

  // Cloudinary APIs
  static String cloudName = dotenv.env['CLOUD_NAME']!;
  static String uploadPreset = dotenv.env['UPLOAD_PRESET']!;

  // Seller APIs
  static String sellerProductsEndpoint = '$baseUri/seller/products';
  static String sellerProductEndpoint = '$baseUri/seller/product';

  // Product APIs
  static String productsEndpoint = '$apiBaseUri/products';
  static String dealOfTheDayEndpoint = '$productsEndpoint/dealoftheday';
}
