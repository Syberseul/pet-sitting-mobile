import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/components/language_switch.dart';
import 'package:flutter_projects/constants/c_routes.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/modules/user.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:flutter_projects/utils/route_args.dart';
import 'package:flutter_projects/utils/stores.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

final storage = FlutterSecureStorage();
final submitBtnController = RoundedLoadingButtonController();

class SignInScreen extends StatefulWidget {
  final SignInArgs? args;

  const SignInScreen({super.key, this.args});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = "";
  String password = "";

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  String emailCounterText = "";
  String passwordCounterText = "";
  bool rememberMe = false;

  bool _isLoading = false;

  late String fcmToken = "";

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    initUserInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> initUserInfo() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    fcmToken = (await getFCMToken())!;

    try {
      final userInfo = await Stores.getCachedUserInfo();

      if (userInfo.isEmpty && widget.args == null) return;

      if (widget.args != null &&
          widget.args!.email.isNotEmpty &&
          widget.args!.password.isNotEmpty) {
        final tempEmail = widget.args?.email ?? "";
        final tempPassword = widget.args?.password ?? "";
        _emailController.text = tempEmail;
        _passwordController.text = tempPassword;
        email = tempEmail;
        password = tempPassword;
      }

      if (mounted && userInfo.isNotEmpty) {
        User newUserInfo = User.fromApiResponse(userInfo);

        final updatedFcmTokens = _mergeFcmTokens(currentTokens: newUserInfo.fcmToken, newToken: fcmToken);
        final updatedUser = newUserInfo.copyWith(fcmTokens: updatedFcmTokens);

        context.read<AuthProvider>().setUser(updatedUser);
        Navigator.pushNamed(context, Routes.dashboardScreen);
      }
    } catch (err) {
      debugPrint("error on init user info: $err");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  void handleSignIn() async {
    if (email.isEmpty || password.isEmpty) return;

    final isValidEmail = validateEmail(email);

    if (!isValidEmail!) {
      setState(() {
        emailCounterText = AppLocalizations.getText(
          context,
          TranslateEnum.invalidEmail,
        );
      });
    }

    if (password.length < 6) {
      setState(() {
        passwordCounterText = AppLocalizations.getText(
          context,
          TranslateEnum.invalidPasswordLen,
        );
      });
    }

    if (isValidEmail && password.length >= 6) {
      try {
        final response = await ApiPost.login(
          context: context,
          email: email,
          password: password,
          rememberMe: rememberMe,
          fcmToken: fcmToken,
        );

        if (response["error"] != null &&
            response["error"].toString().isNotEmpty) {
          printColor("${response["error"]}", textColor: TextColor.red);
          submitBtnController.error();
        } else {
          if (mounted) {
            context.read<AuthProvider>().setUser(
              User.fromApiResponse(response),
            );
            submitBtnController.success();
            Navigator.pushNamed(context, Routes.dashboardScreen);
          }
        }
      } catch (err) {
        printColor("ERROR: $err", textColor: TextColor.red);
        submitBtnController.error();
      }
    }
  }

  List<String> _mergeFcmTokens({
    required List<String> currentTokens,
    required String? newToken
}) {
    if (newToken == null) return currentTokens;
    return currentTokens.contains(newToken) ? currentTokens : [...currentTokens, newToken];
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return CircularProgressIndicator();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              spacing: 10.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "logo-avatar",
                  child: SvgPicture.asset("assets/images/logo.svg"),
                ),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.getText(
                      context,
                      TranslateEnum.emailAddress,
                    ),
                    counterText: emailCounterText,
                    counterStyle:
                        emailCounterText.isNotEmpty
                            ? TextStyle(color: Colors.red[600])
                            : null,
                  ),
                  onChanged:
                      (val) => {
                        email = val,
                        setState(() {
                          emailCounterText = "";
                        }),
                      },
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.getText(
                      context,
                      TranslateEnum.password,
                    ),
                    counterText: passwordCounterText,
                    counterStyle:
                        passwordCounterText.isNotEmpty
                            ? TextStyle(color: Colors.red[600])
                            : null,
                  ),
                  onChanged:
                      (val) => {
                        password = val,
                        setState(() {
                          passwordCounterText = "";
                        }),
                      },
                ),
                Row(
                  spacing: 20.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: rememberMe,
                          onChanged:
                              (bool? bol) => setState(() {
                                rememberMe = !rememberMe;
                              }),
                        ),
                        Text(
                          AppLocalizations.getText(
                            context,
                            TranslateEnum.rememberMe,
                          ),
                        ),
                      ],
                    ),
                    RoundedLoadingButton(
                      controller: submitBtnController,
                      onPressed:
                          email.isNotEmpty && password.isNotEmpty
                              ? handleSignIn
                              : null,
                      width: 150.0,
                      height: 40.0,
                      resetAfterDuration: true,
                      resetDuration: Duration(seconds: 3),
                      child: Text(
                        AppLocalizations.getText(context, TranslateEnum.signIn),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.getText(context, TranslateEnum.or)),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushNamed(context, Routes.signUpScreen),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        textStyle: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.getText(
                          context,
                          TranslateEnum.goToSignUp,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.getText(
                        context,
                        TranslateEnum.createAccount,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(right: 16, bottom: 16, child: LanguageSwitch()),
        ],
      ),
    );
  }
}
