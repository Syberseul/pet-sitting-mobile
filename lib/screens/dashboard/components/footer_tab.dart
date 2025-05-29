import 'package:flutter/material.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';

class FooterTab extends StatelessWidget {
  const FooterTab({
    super.key,
    required this.tabName,
    required this.isSelected,
    required this.tabIcon,
    required this.onClick,
  });

  final TranslateEnum tabName;
  final bool isSelected;
  final IconData tabIcon;
  final VoidCallback onClick;

  final Color selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? Colors.white : Colors.black45;

    return InkWell(
      onTap: onClick,
      splashColor: Colors.white.withAlpha(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(tabIcon, color: color),
          SizedBox(height: 4),
          Text(AppLocalizations.getText(context, tabName), style: TextStyle(color: color))
        ],
      ),
    );
  }
}