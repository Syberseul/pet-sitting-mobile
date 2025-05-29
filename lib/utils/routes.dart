import 'package:flutter/cupertino.dart';
import 'package:flutter_projects/screens/auth_screen/sign_in_screen/index.dart';
import 'package:flutter_projects/utils/route_args.dart';

abstract class InitRoute {
  const InitRoute();
}

class SignInRoutes extends InitRoute {
  static SignInScreen getRoute (BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as SignInArgs?;
    return SignInScreen(args: args);
  }
}
