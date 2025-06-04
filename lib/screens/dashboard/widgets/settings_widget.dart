import 'package:colorful_print/colorful_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/components/language_switch.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

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
            _buildLanguageSwitcher(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}