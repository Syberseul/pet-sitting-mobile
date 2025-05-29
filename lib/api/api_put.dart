import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:flutter_projects/api/api_config.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/utils/stores.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final String _baseUrl = ApiConfig.baseUrl;
final Map<String, String> _headerConfig = ApiConfig.headerConfig;
final User? userInfo =
    navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

class ApiPut {
  static Future<dynamic> putRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    if (userInfo == null) {
      return {};
    }

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {
          ..._headerConfig,
          ...?headers,
          "authorization": "Bearer ${userInfo!.token}",
        },
        body: jsonEncode(body)
      );

      final data = jsonDecode(response.body);

      if (data is Map && data["error"] == "Token has expired") {
        await Stores.refreshToken();

        final newUserInfo =
            navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

        if (newUserInfo == null) {
          return {};
        }

        final newResponse = await http.put(
          Uri.parse("$_baseUrl/$endpoint").replace(queryParameters: body),
          headers: {
            ..._headerConfig,
            ...?headers,
            "authorization": "Bearer ${newUserInfo.token}",
          },
        );

        return jsonDecode(newResponse.body);
      }

      return jsonDecode(response.body);
    } catch (err) {
      throw Exception("Request failed: $err");
    }
  }

  static Future<Map<String, dynamic>> updateTour({
    required Tour tourInfo
}) async {
    try {
      final response = await putRequest(
        endpoint: "tour/updateTour/${tourInfo.id}",
        body: tourInfo.toJson(),
      );
      return response;
    } catch (err) {
      throw Exception("Failed to update tour: $err");
    }
  }
}
