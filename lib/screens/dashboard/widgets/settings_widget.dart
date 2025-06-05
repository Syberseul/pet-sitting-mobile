import 'dart:io';

import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/api/api_put.dart';
import 'package:flutter_projects/components/language_switch.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  bool isUpdatingNoticeReceivable = false;

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
              AppLocalizations.getText(context, TranslateEnum.settingTab),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            _settingSection(context),
          ],
        ),
      ),
    );
  }

  Widget _settingSection(BuildContext context) {
    var userInfo = context.read<AuthProvider>().getUserInfo!;
    final userRole = userInfo.role;
    final userCouldReceiveNotification =
        userRoleList[userRole] == UserRole.admin ||
        userRoleList[userRole] == UserRole.developer;
    bool noticeReceivable = userInfo.receiveNotification;

    Future<void> updateNoticeReceivable(bool newValue) async {
      if (isUpdatingNoticeReceivable) return;

      setState(() => isUpdatingNoticeReceivable = true);

      try {
        final response = await ApiPut.updateReceiveNotification(
          userId: userInfo.id,
          receivable: newValue,
        );

        if (response["error"] != null) return;

        context.read<AuthProvider>().updateUser(receiveNotifications: newValue);
        setState(() => noticeReceivable = newValue);
      } catch (err) {
        debugPrint("$err");
      } finally {
        setState(() => isUpdatingNoticeReceivable = false);
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 500.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 15.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10.0,
                  children: <Widget>[
                    Text(
                      AppLocalizations.getText(context, TranslateEnum.settings),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.settings, color: Colors.lightBlueAccent),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AppLocalizations.getText(
                        context,
                        TranslateEnum.languageSetting,
                      ),
                    ),
                    LanguageSwitch(),
                  ],
                ),
                if (userCouldReceiveNotification)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppLocalizations.getText(
                          context,
                          TranslateEnum.notificationSetting,
                        ),
                      ),
                      Switch(
                        value: noticeReceivable,
                        activeColor: Colors.lightBlueAccent,
                        onChanged:
                            isUpdatingNoticeReceivable
                                ? null
                                : (bool newValue) async {
                                  await updateNoticeReceivable(newValue);
                                },
                        thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                          Set<WidgetState> states,
                        ) {
                          if (isUpdatingNoticeReceivable) {
                            return const Icon(Icons.autorenew_rounded);
                          }
                          return Icon(
                            noticeReceivable ? Icons.alarm_on : Icons.alarm_off,
                            color: Colors.white,
                          );
                        }),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
