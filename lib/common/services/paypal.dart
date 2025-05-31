import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

class PayPalService {
  static const String clientId =
      "AWJBCLFiIsrzI-0r_VpS8t-jXR6t6UVE27gNQUneoDptv8Q-AQ1usaH7UM7lkmR4pkOdAiwIlsP4L86S";
  static const String secret =
      "EEblUyLHoOxFedZCtdn4-29ANwgg_sPVUp-u5sGL-0nbZ-Z6F87v_-ZFbbCngk_pneqIRHYBwyH-hBGC";
  static const String domain = "https://sandbox.paypal.com";

  static final Dio _dio = Dio();

  static Future<String?> getAccessToken() async {
    final basicAuth = base64Encode(utf8.encode('$clientId:$secret'));

    try {
      final response = await _dio.post(
        "$domain/v1/oauth2/token",
        options: Options(
          headers: {
            'Authorization': 'Basic $basicAuth',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {'grant_type': 'client_credentials'},
      );

      return response.data['access_token'];
    } catch (e) {
      log("Failed to get token: $e");
      return null;
    }
  }

  static Future<String?> createOrder(String accessToken, String amount) async {
    try {
      final response = await _dio.post(
        "$domain/v2/checkout/orders",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "amount": {"currency_code": "USD", "value": amount},
            },
          ],
        },
      );

      return response.data['id'];
    } catch (e) {
      log("Failed to create order: $e");
      return null;
    }
  }
}
