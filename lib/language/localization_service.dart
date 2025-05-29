import 'package:flutter/material.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'locals/en.dart';
import 'locals/zh.dart';

class AppLocalizations {
  final Locale locale;
  static Map<TranslateEnum, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<void> load() async {
    switch (locale.languageCode) {
      case 'zh':
        _localizedStrings = Map<TranslateEnum, String>.from(zh);
        break;
      default:
        _localizedStrings = Map<TranslateEnum, String>.from(en);
    }
  }

  String translate(TranslateEnum key, [List<dynamic>? args]) {
    String value = _localizedStrings[key] ?? key.toString();
    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        value = value.replaceAll('%${i + 1}', args[i].toString());
      }
    }
    return value;
  }

  static String getText(BuildContext context, TranslateEnum key, [List<dynamic>? args]) {
    return of(context)?.translate(key, args) ?? key.toString();
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}