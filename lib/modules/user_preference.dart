import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreference {
  static const String _storageKey = 'user_preference';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String language = "en";

  UserPreference({this.language = "en"});

  static Future<UserPreference> load() async {
    try {
      final storage = const FlutterSecureStorage();
      final jsonString = await storage.read(key: _storageKey);

      if (jsonString != null) {
        final data = jsonDecode(jsonString);
        return UserPreference(language: data['language'] ?? "en");
      }
      return UserPreference();
    } catch (e) {
      debugPrint('Failed loading user preference: $e');
      return UserPreference();
    }
  }

  Future<void> setUserPreference({String? newLanguage}) async {
    if (newLanguage != null) {
      language = newLanguage;
      await _storage.write(
        key: _storageKey,
        value: jsonEncode({'language': language}),
      );
    }
  }

  Future<void> clearPreference() async {
    await _storage.delete(key: _storageKey);
  }
}