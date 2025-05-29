import 'package:colorful_print/colorful_print.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/constants/c_breedMap.dart';
import 'package:flutter_projects/constants/enum.dart';
import 'package:flutter_projects/language/localization_service.dart';
import 'package:flutter_projects/language/trans_enum.dart';
import 'package:flutter_projects/main.dart';
import 'package:flutter_projects/modules/owner.dart';
import 'package:flutter_projects/modules/user_preference.dart';

bool? validateEmail(String email) => EmailValidator.validate(email);

double getAverageWeight(List<double> weightRange) {
  if (weightRange.isEmpty) return 0.0;

  double ave = 0.0;

  for (int i = 0; i < weightRange.length; i++) {
    ave += (weightRange[i] - ave) / (i + 1);
  }

  return ave;
}

DogSize getDogSize(double aveWeight) {
  if (aveWeight < 5) {
    return DogSize.xSmall;
  } else if (aveWeight < 15) {
    return DogSize.small;
  } else if (aveWeight < 30) {
    return DogSize.medium;
  } else if (aveWeight < 50) {
    return DogSize.large;
  } else {
    return DogSize.xLarge;
  }
}

double getDogDailyPrice(DogSize dogSize) {
  return dailyPriceList[dogSize] ?? 0.0;
}

Map<String, Owner> convertListToOwnerMap(List<dynamic> ownerList) {
  final Map<String, Owner> result = {};

  for (final owner in ownerList) {
    if (owner is Owner) {
      result[owner.id] = owner;
    }
  }

  return result;
}

double getDogDailyPriceByBreed(String breedType) {
  if (breedType.isEmpty) return 0;

  final breedInfo = BreedInfo.getBreedInfo(breedType);

  if (breedInfo == null) return 0;

  final aveWeight = getAverageWeight(breedInfo.normalWeightRange);

  return getDogDailyPrice(getDogSize(aveWeight));
}

bool isSameDate(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String displayDateInCalendar(DateTime date, bool withinMonth) {
  final day = date.day.toString();
  if (withinMonth) return day;

  final month = date.month.toString().padLeft(2, "0");
  return "${month} - ${day.padLeft(2, "0")}";
}

Future<void> changeLanguage(BuildContext context, String languageCode) async {
  try {
    MyApp.of(context)?.setLocale(Locale(languageCode));

    final pref = await UserPreference.load();
    await pref.setUserPreference(newLanguage: languageCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageCode == 'zh' ? "成功切换 中文" : "Switch language to English",
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("change failed")));
    debugPrint('语言切换失败: $e');
  }
}

Map<String, dynamic> parseDateTimeRange(
  BuildContext context,
  DateTimeRange dateRange,
) {
  final startDate = dateRange.start;
  final endDate = dateRange.end;
  final currentYear = DateTime.now().year;
  final inSameYear = startDate.year == endDate.year;

  final startDateList = [
    startDate.year,
    startDate.month.toString().padLeft(2, '0'),
    startDate.day.toString().padLeft(2, '0'),
  ];
  final endDateList = [
    endDate.year,
    endDate.month.toString().padLeft(2, '0'),
    endDate.day.toString().padLeft(2, '0'),
  ];

  final selectedLanguage = Localizations.localeOf(context).languageCode;

  final startDateStr =
      selectedLanguage == "en"
          ? inSameYear && currentYear == startDate.year
              ? "${startDateList[2]} / ${startDateList[1]}"
              : startDateList.reversed.join(" / ")
          : selectedLanguage == "zh"
          ? inSameYear && currentYear == startDate.year
              ? "${startDateList[1]} / ${startDateList[2]}"
              : startDateList.join(" / ")
          : "";
  final fullStartDateStr = startDateList.join("-");

  final endDateStr =
      selectedLanguage == "en"
          ? inSameYear && currentYear == endDate.year
              ? "${endDateList[2]} / ${endDateList[1]}"
              : endDateList.reversed.join(" / ")
          : selectedLanguage == "zh"
          ? inSameYear && currentYear == endDate.year
              ? "${endDateList[1]} / ${endDateList[2]}"
              : endDateList.join(" / ")
          : "";
  final fullEndDateStr = endDateList.join("-");

  final days = endDate.difference(startDate).inDays + 1;

  return {
    'start': startDateStr,
    'end': endDateStr,
    'days': days,
    "fullStartDateStr": fullStartDateStr,
    "fullEndDateStr": fullEndDateStr,
  };
}

Future<String?> getFCMToken() async {
  await FirebaseMessaging.instance.requestPermission();

  String? token = await FirebaseMessaging.instance.getToken();

  return token;
}