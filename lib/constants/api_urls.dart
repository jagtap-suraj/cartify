import 'package:flutter_dotenv/flutter_dotenv.dart';

// Base host and port
String baseHost = dotenv.env['HOST']!;
String basePort = dotenv.env['PORT']!;

// Complete base URI
String baseUri = 'http://$baseHost:$basePort';

// API base URI
String apiBaseUri = '$baseUri/api';

// Specific API endpoints
String signInEndpoint = '$apiBaseUri/signin';
String signUpEndpoint = '$apiBaseUri/signup';
String getUserEndpoint = '$apiBaseUri/user';
String tokenValidationEndpoint = '$apiBaseUri/istokenvalid';
