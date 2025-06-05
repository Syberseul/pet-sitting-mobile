import 'package:colorful_print/colorful_print.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/trans_enum.dart';

class User {
  late final String _id;
  late final String _email;
  late final String _userName;
  late final String _token;
  late final String _refreshToken;
  late final int _role;
  late final List<String> _fcmTokens;
  late final bool _receiveNotifications;

  @override
  String toString() {
    return 'User{'
        'id: $_id, '
        'email: $_email, '
        'token: ${_token.isNotEmpty ? "[hidden]" : "null"}, '
        'refreshToken: ${_refreshToken.isNotEmpty ? "[hidden]" : "null"}, '
        'role: $_role, '
        'fcmTokens: $_fcmTokens, '
        'receiveNotifications: $_receiveNotifications, '
        '}';
  }

  factory User.fromApiResponse(Map<String, dynamic> response) {
    return User(
      id: response['uid']?.toString() ?? response['id']?.toString() ?? "",
      email: response['email']?.toString() ?? '',
      token: response['token']?.toString() ?? '',
      refreshToken: response['refreshToken']?.toString() ?? '',
      role: response['role'] ?? 0,
      fcmTokens: response['fcmTokens'] as List<String>? ?? [],
      receiveNotifications: response["receiveNotifications"] ?? [
        UserRole.admin,
        UserRole.developer,
      ].contains(userRole[response['role']])
    );
  }

  User({
    required String id,
    required String email,
    required String token,
    required String refreshToken,
    required int role,
    String userName = "",
    required List<String> fcmTokens,
    bool receiveNotifications = false,
  }) : _id = id,
       _email = email,
       _token = token,
       _refreshToken = refreshToken,
       _userName = userName,
       _role = role,
       _fcmTokens = fcmTokens,
       _receiveNotifications = receiveNotifications;

  String get id => _id;
  String get email => _email;
  String get userName => _userName;
  String get token => _token;
  String get refreshToken => _refreshToken;
  int get role => _role;
  List<String> get fcmToken => _fcmTokens;
  bool get receiveNotification => _receiveNotifications;
  Map<String, dynamic> get toMap => {
    "id": _id,
    "email": _email,
    "role": _role,
    "token": _token,
    "refreshToken": _refreshToken,
    "fcmTokens": _fcmTokens,
    "receiveNotification": _receiveNotifications,
  };

  static User setUser(Map<String, dynamic> userInfo) => User(
    id: userInfo['id']?.toString() ?? '',
    email: userInfo['email']?.toString() ?? '',
    token: userInfo['token']?.toString() ?? '',
    refreshToken: userInfo['refreshToken']?.toString() ?? '',
    userName: userInfo['userName']?.toString() ?? '',
    role: userInfo['role'] ?? 0,
    fcmTokens: userInfo["fcmTokens"] ?? [],
    receiveNotifications:
        userInfo["receiveNotifications"] ??
        [
          UserRole.admin,
          UserRole.developer,
        ].contains(userRole[userInfo['role']]),
  );

  TranslateEnum? getUserRole() => userRoleName[userRole[role]];

  User copyWith({
    String? email,
    String? token,
    String? refreshToken,
    List<String>? fcmTokens,
    bool? receiveNotifications,
  }) {
    return User(
      id: _id,
      role: _role,
      email: email ?? _email,
      token: token ?? _token,
      refreshToken: refreshToken ?? _refreshToken,
      fcmTokens: fcmTokens ?? _fcmTokens,
      receiveNotifications:
        receiveNotifications ??
          [UserRole.admin, UserRole.developer].contains(userRole[_role]),
    );
  }
}

Map<int, UserRole> userRole = {
  0: UserRole.visitor,
  10: UserRole.dogOwner,
  90: UserRole.developer,
  100: UserRole.admin,
};

Map<UserRole, TranslateEnum> userRoleName = {
  UserRole.admin: TranslateEnum.userRoleAdmin,
  UserRole.developer: TranslateEnum.userRoleDeveloper,
  UserRole.dogOwner: TranslateEnum.userRoleDogOwner,
  UserRole.visitor: TranslateEnum.userRoleVisitor,
};
