import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_projects/modules/user.dart';

class AuthProvider with ChangeNotifier, DiagnosticableTreeMixin {
  User? _userInfo;

  User? get getUserInfo => _userInfo;

  void setUser(User newUser) {
    if (_userInfo != newUser) {
      _userInfo = newUser;
      notifyListeners();
    }
  }

  void updateUser({
    String? email,
    String? token,
    String? refreshToken,
    List<String>? fcmTokens,
    bool? receiveNotifications,
  }) {
    if (_userInfo != null) {
      _userInfo = _userInfo!.copyWith(
          email: email,
          token: token,
          refreshToken: refreshToken,
          fcmTokens: fcmTokens,
        receiveNotifications: receiveNotifications
      );
      notifyListeners();
    }
  }

  void clearUser() {
    _userInfo = null;
    notifyListeners();
  }
}