import 'dart:convert';

import 'package:http/http.dart' as http;

String? httpErrorHandle({
  required http.Response response,
}) {
  if (response.statusCode == 200) {
    // If the call to the server was successful, return null indicating no error
    return null;
  } else {
    // Handle different status codes and return appropriate error messages
    switch (response.statusCode) {
      case 400:
        return jsonDecode(response.body)['msg'];
      case 500:
        return jsonDecode(response.body)['error'];
      default:
        return response.body;
    }
  }
}
