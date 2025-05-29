import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:flutter_projects/api/api_config.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/utils/stores.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final String _baseUrl = ApiConfig.baseUrl;
final Map<String, String> _headerConfig = ApiConfig.headerConfig;

class ApiGet {
  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final User? userInfo =
        navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

    if (userInfo == null) {
      return {};
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {
          ..._headerConfig,
          ...?headers,
          "authorization": "Bearer ${userInfo!.token}",
        },
      );

      final data = jsonDecode(response.body);

      if (data is Map && data["error"] == "Token has expired") {
        await Stores.refreshToken();

        final newUserInfo =
            navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

        if (newUserInfo == null) {
          return {};
        }

        final newResponse = await http.get(
          Uri.parse("$_baseUrl/$endpoint"),
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

  static Future<List<Map<String, dynamic>>> getTours() async {
    try {
      final response = await getRequest(endpoint: "tour/getTours");
      return response.cast<Map<String, dynamic>>();
    } catch (err) {
      printColor("error fetch tours $err", textColor: TextColor.red);
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getOwners() async {
    try {
      final response = await getRequest(endpoint: "owner/all");
      return response.cast<Map<String, dynamic>>();
    } catch (err) {
      printColor("error fetch owners $err", textColor: TextColor.red);
      return [];
    }
  }

  static Future<String> getDogImage(String dogNameUrl) async {
    if (dogNameUrl.contains("cavoodle")) {
      dogNameUrl = dogNameUrl.replaceAll("cavoodle", "cavapoo");
    }
    final response = await http.get(
      Uri.parse("https://dog.ceo/api/breed/$dogNameUrl/images/random"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["message"];
    } else {
      throw Exception("Failed to fetch dog image");
    }
  }
}
