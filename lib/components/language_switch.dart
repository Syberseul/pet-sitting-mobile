import 'package:flutter/material.dart';
import 'package:flutter_projects/utils/helpers.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  @override
  Widget build(BuildContext context) {
    int currentLangIndex =
        Localizations.localeOf(context).languageCode == 'zh' ? 1 : 0;

    return ToggleSwitch(
      initialLabelIndex: currentLangIndex,
      totalSwitches: 2,
      labels: ["ENG", "中文"],
      activeBgColors: [
        [Colors.lightBlueAccent, Colors.blue],
        [Colors.blue, Colors.lightBlueAccent],
      ],
      inactiveBgColor: Colors.grey,
      customTextStyles:[TextStyle(fontWeight: FontWeight.bold)],
      onToggle: (index) async {
        final langList = ["en", "zh"];
        await changeLanguage(context, langList[index!]);
        setState(() {
          currentLangIndex = index;
        });
      },
    );
  }
}
