import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePeService {
  // PhonePe Variables
  final String environment = dotenv.env['PHONEPE_ENVIRONMENT']!;
  final String appId = dotenv.env['PHONEPE_APP_ID'] ?? "";
  final String merchantId = dotenv.env['PHONEPE_MERCHANT_ID']!;
  final String saltKey = dotenv.env['PHONEPE_SALT_KEY']!;
  final int saltIndex = int.parse(dotenv.env['PHONEPE_SALT_INDEX']!);
  final bool enableLogging = true;
  final String callbackUrl = "https://webhook.site/41321f26-4bdc-4d11-a474-d5c4ecd79ec1";
  String checksum = "";
  final String apiEndPoint = "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay";
  final String apiEndPoint2 = "/pg/v1/pay";
  String body = "";
  Object? response;

  String getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": 1000,
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {
        "type": "PAY_PAGE",
      },
    };
    String base64Body = base64.encode(utf8.encode(jsonEncode(requestData)));

// String checksum = sha256(base64Body + apiEndPoint + salt) + ### + saltIndex;

    checksum = '${sha256.convert(utf8.encode(base64Body + apiEndPoint2 + saltKey)).toString()}###$saltIndex';
    print("sooraj checksum: $checksum");
    return base64Body;
  }

  Future<bool> initPhonePay() async {
    response = await PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging);
    print("sooraj PhonePe SDK Initialized: $response");
    return response as bool;
  }

  Future<Map<dynamic, dynamic>?> startPGTransaction() async {
    try {
      body = getChecksum();
      var response = await PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "");
      print("sooraj PhonePe Transaction Response: ${response.toString()}");
      print("sooraj status: ${response!['status'].toString()}");
      return response;
    } catch (e) {
      print("sooraj PhonePe Transaction Error: ${e.toString()}");
      return null;
    }
  }
}
