import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/components/language_switch.dart';
import 'package:flutter_projects/constants/c_routes.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:flutter_projects/utils/route_args.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:toggle_switch/toggle_switch.dart';

final submitBtnController = RoundedLoadingButtonController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email = "";
  String password = "";
  String confirmPassword = "";

  String emailCounterText = "";
  String passwordCounterText = "";
  String confirmPasswordCounterText = "";

  void handleSignUp() async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) return;

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
    } else if (password != confirmPassword) {
      setState(() {
        confirmPasswordCounterText = "Password does not matched";
      });
    }

    if (isValidEmail && password.length >= 6 && password == confirmPassword) {
      try {
        final response = await ApiPost.signUp(email: email, password: password);

        if (response["error"] != null) {
          printColor("error ${response["error"]}", textColor: TextColor.red);
          submitBtnController.error();
        } else {
          submitBtnController.success();
          if (mounted) {
            Navigator.pushNamed(
              context,
              Routes.signInScreen,
              arguments: SignInArgs(email: email, password: password),
            );
          }
        }
      } catch (err) {
        printColor("error $err", textColor: TextColor.red);
        submitBtnController.error();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: SvgPicture.asset(
                    "assets/images/logo.svg",
                    width: 80.0,
                    height: 120.0,
                  ),
                ),
                TextField(
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
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.getText(
                      context,
                      TranslateEnum.confirmPassword,
                    ),
                    counterText: confirmPasswordCounterText,
                    counterStyle:
                        confirmPasswordCounterText.isNotEmpty
                            ? TextStyle(color: Colors.red[600])
                            : null,
                  ),
                  onChanged:
                      (val) => {
                        confirmPassword = val,
                        setState(() {
                          confirmPasswordCounterText = "";
                        }),
                      },
                ),
                RoundedLoadingButton(
                  controller: submitBtnController,
                  onPressed:
                      email.isNotEmpty &&
                              password.isNotEmpty &&
                              confirmPassword.isNotEmpty &&
                              password == confirmPassword
                          ? handleSignUp
                          : null,
                  width: 200.0,
                  height: 40.0,
                  resetAfterDuration: true,
                  resetDuration: Duration(seconds: 3),
                  child: Text(
                    AppLocalizations.getText(context, TranslateEnum.signUp),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.getText(context, TranslateEnum.or)),
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushNamed(context, Routes.signInScreen),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        textStyle: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.getText(
                          context,
                          TranslateEnum.goToSignIn,
                        ),
                      ),
                    ),
                    Text(
                      AppLocalizations.getText(
                        context,
                        TranslateEnum.loginViaAccount,
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
