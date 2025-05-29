import 'dart:convert';

import 'package:colorful_print/colorful_print.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/constants/c_routes.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/modules/user_preference.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/providers/owner_provider.dart';
import 'package:flutter_projects/providers/tour_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

final storage = FlutterSecureStorage();
final storeUserInfo = "userInfo";
final userPreference = "userPreference";
final authProviderRef = navigatorKey.currentContext?.read<AuthProvider>();
final tourProviderRef = navigatorKey.currentContext?.read<TourProvider>();
final ownerProviderRef = navigatorKey.currentContext?.read<OwnerProvider>();

bool rememberUser = false;

class Stores {
  static Future<void> cacheUserInfo(
    BuildContext context,
    Map<String, dynamic> userInfo,
    bool rememberMe,
  ) async {
    final loginUserInfo = User.fromApiResponse(userInfo);

    context.read<AuthProvider>().setUser(loginUserInfo);
    if (rememberMe) {
      rememberUser = true;
      await storage.write(key: storeUserInfo, value: jsonEncode(userInfo));
    }
  }

  static Future<Map<String, dynamic>> getCachedUserInfo() async {
    final String userInfo = await storage.read(key: storeUserInfo) ?? "";
    rememberUser = userInfo.isNotEmpty;

    return userInfo.isEmpty ? {} : jsonDecode(userInfo);
  }

  static Future<void> removeUserInfo() async {
    authProviderRef?.clearUser();
    rememberUser = false;
    await FirebaseAuth.FirebaseAuth.instance.signOut();
    await storage.delete(key: storeUserInfo);
    tourProviderRef?.updateTours([]);
    ownerProviderRef?.resetOwner();
  }

  static refreshToken() async {
    try {
      final user = authProviderRef?.getUserInfo;
      if (user == null) {
        debugPrint("No user found when refresh token");
      }

      final response = await ApiPost.postRequest(
        endpoint: "users/refreshToken",
        body: {
          "uid": user!.id,
          "token": user.token,
          "refreshToken": user.refreshToken,
        },
      );

      if (response["token"]?.toString().isNotEmpty ?? false) {
        final customToken = response["token"];
        final userCredential = await FirebaseAuth.FirebaseAuth.instance.signInWithCustomToken(customToken);
        final idToken = await userCredential.user!.getIdToken();

        authProviderRef?.updateUser(
          token: idToken,
          refreshToken: response["refreshToken"].toString(),
        );

        if (rememberUser) {
          final updatedUser = authProviderRef?.getUserInfo;
          if (updatedUser != null) {
            await storage.write(
              key: storeUserInfo,
              value: jsonEncode(updatedUser.toMap),
            );
          }
        }
      }
    } catch (err) {
      debugPrint("Token refresh error: $err");
      await ApiPost.logOut();
      Navigator.popAndPushNamed(navigatorKey.currentContext!, Routes.signInScreen);
    }
  }

  static Future<void> saveUserPreference(UserPreference newPreference) async {
    try {
      await newPreference.setUserPreference(newLanguage: newPreference.language);
    } catch (e) {
      debugPrint('保存用户偏好失败: $e');
      rethrow;
    }
  }

  // 新增：获取当前语言偏好
  static Future<String> getCurrentLanguage() async {
    final pref = await UserPreference.load();
    return pref.language;
  }
}
