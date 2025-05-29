import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_post.dart';
import 'package:flutter_projects/components/language_switch.dart';
import 'package:flutter_projects/constants/c_routes.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyAccountWidget extends StatelessWidget {
  const MyAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 15.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.getText(context, TranslateEnum.myAccountTab),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _buildAccountInfoCard(context),
            Spacer(),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard(BuildContext context) {
    final userInfo = context.read<AuthProvider>().getUserInfo;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DefaultTextStyle(
              style: TextStyle(fontSize: 20, color: Colors.black87),
              child: Row(
                children: <Widget>[
                  Text(
                    "${AppLocalizations.getText(context, TranslateEnum.role)}: ",
                  ),
                  Text(
                    AppLocalizations.getText(context, userInfo!.getUserRole()!),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Text(
              userInfo.userName.isEmpty
                  ? userInfo.email
                  : "${userInfo.userName} (${userInfo.email})",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[100],
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () async {
        await ApiPost.logOut();
        Navigator.popAndPushNamed(context, Routes.signInScreen);
      },
      child: Text(
        AppLocalizations.getText(context, TranslateEnum.logOut),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
