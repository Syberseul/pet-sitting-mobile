import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/api/api_config.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/owner.dart';
import 'package:flutter_projects/modules/tour.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:flutter_projects/utils/stores.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final String _baseUrl = ApiConfig.baseUrl;
final Map<String, String> _headerConfig = ApiConfig.headerConfig;
final User? userInfo =
    navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

class ApiPost {
  static Future<Map<String, dynamic>> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/$endpoint"),
        headers: {..._headerConfig, ...?headers},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (data is Map && data["error"] == "Token has expired") {
        await Stores.refreshToken();
        final newUserInfo =
            navigatorKey.currentContext?.read<AuthProvider>().getUserInfo;

        if (newUserInfo == null || newUserInfo.token.isEmpty) {
          throw Exception("User not authenticated after token refresh");
        }

        final retryResponse = await http.post(
          Uri.parse("$_baseUrl/$endpoint"),
          headers: {
            ..._headerConfig,
            ...?headers,
            "authorization": "Bearer ${newUserInfo.token}",
          },
          body: jsonEncode(body),
        );

        return jsonDecode(retryResponse.body);
      }

      return jsonDecode(response.body);
    } catch (err) {
      throw Exception("Request failed: $err");
    }
  }

  static Future<Map<String, dynamic>> login({
    required BuildContext context,
    required String email,
    required String password,
    required String fcmToken,
    bool rememberMe = false,
  }) async {
    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};

      if (rememberMe && fcmToken.isNotEmpty) {
        requestBody["fcmToken"] = fcmToken;
      }

      var response = await postRequest(
        endpoint: "users/login",
        body: requestBody,
      );

      try {
        final customToken = response["token"];
        final userCredential = await FirebaseAuth.FirebaseAuth.instance.signInWithCustomToken(customToken);
        final idToken = await userCredential.user!.getIdToken(true);

        response = {
          ...response,
          "token": idToken,
        };

        await Stores.cacheUserInfo(context, response, rememberMe);

        return response;
      } on FirebaseAuth.FirebaseAuthException catch (e) {
        printColor("Invalid firebase auth token", textColor: TextColor.red);
        return {};
      }
    } catch (err, stack) {
      printColor("error $err", textColor: TextColor.red);
      printColor("stack $stack", textColor: TextColor.red);
      return {};
    }
  }

  static Future<Map<String, dynamic>> logOut() async {
    try {
      final fcmToken = await getFCMToken();

      await postRequest(
        endpoint: "users/logout",
        body: {"fcmToken": fcmToken, "userId": userInfo!.id},
      );

      await Stores.removeUserInfo();
      return {};
    } catch (err) {
      printColor("error $err", textColor: TextColor.red);
      return {};
    }
  }

  static Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    final response = await postRequest(
      endpoint: "users/register",
      body: {"email": email, "password": password},
    );

    return response;
  }

  static Future<Map<String, dynamic>> createDogOwner({
    required Owner ownerInfo,
  }) async {
    final response = await postRequest(
      endpoint: "owner/create",
      headers: {"authorization": "Bearer ${userInfo!.token}"},
      body: ownerInfo.toJson(),
    );

    return response;
  }

  static Future<Map<String, dynamic>> createTours({
    required List<Tour> toursInfo,
  }) async {
    final List<Map<String, dynamic>> successTours = [];
    final List<Map<String, dynamic>> failedTours = [];

    for (final Tour tour in toursInfo) {
      try {
        final response = await postRequest(
          endpoint: "tour/createTour",
          headers: {"authorization": "Bearer ${userInfo!.token}"},
          body: tour.toJson(),
        );

        final createdTour = Tour.fromApiResponse(response);

        if (createdTour.id.isNotEmpty) {
          successTours.add(createdTour.tourInfo);
        } else {
          failedTours.add(createdTour.tourInfo);
        }
      } catch (err) {
        failedTours.add({"error": err.toString()});
      }
    }

    return {
      "successTours": successTours,
      "failedTours": failedTours,
      "totalSuccess": successTours.length,
      "totalFailed": failedTours.length,
    };
  }
}
