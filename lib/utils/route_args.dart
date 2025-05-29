abstract class BaseRouteArgs {
  const BaseRouteArgs();
}

class SignInArgs extends BaseRouteArgs {
  final String email;
  final String password;

  const SignInArgs({this.email = "", this.password = ""});
}