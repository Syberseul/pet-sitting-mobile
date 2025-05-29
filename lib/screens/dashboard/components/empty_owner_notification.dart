import 'package:flutter/material.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';

class EmptyOwnerNotification extends StatelessWidget {
  const EmptyOwnerNotification({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.getText(context, TranslateEnum.noDogOwnerText),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: ButtonStyle().copyWith(
            backgroundColor: WidgetStateProperty.all(Colors.lightBlueAccent),
          ),
          child: Text(AppLocalizations.getText(context, TranslateEnum.createNow), style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),),
        ),
      ],
    );
  }
}
