import 'dart:convert';
import 'package:cartify/constants/app_strings.dart';
import 'package:http/http.dart' as http;

String? httpErrorHandler({
  required http.Response response,
}) {
  if (response.statusCode == 200) {
    return null; // No error
  }
  switch (response.statusCode) {
    case 400:
      // Handle Bad Request
      return jsonDecode(response.body)['msg'];
    case 422:
      // Handle Unprocessable Entity, possibly due to validation errors
      final errors = jsonDecode(response.body)['errors'] as List<dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final errorMessages = errors.map((e) => e['msg']).join(', ');
        return errorMessages;
      }
      return jsonDecode(response.body)['msg'] ?? AppStrings.validationErrorOccurred;
    case 500:
      // Handle Internal Server Error
      return jsonDecode(response.body)['error'];
    default:
      return response.body;
  }
}
