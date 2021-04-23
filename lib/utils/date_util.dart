import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';

class DateUtil{

  DateUtil._();

  static String parseTime(BuildContext context, String formattedTime){
    DateTime now = DateTime.now();
    DateTime parsed = DateTime.parse(formattedTime);
    if(now.isBefore(parsed)){
      return '';
    }
    Duration diff = now.difference(parsed);
    if(diff.inHours == 0){
      return AppLocalizations.of(context).just;
    }
    if(diff.inDays == 0){
      return '${diff.inHours}${AppLocalizations.of(context).hoursAgo}';
    }
    if(diff.inDays < 31){
      return '${diff.inDays}${AppLocalizations.of(context).daysAgo}';
    }
    if(now.year == parsed.year){
      return !CommonUtil.isEnglishMode(context)
          ? '${parsed.month}月${parsed.day}号'
          : '${parsed.day} ${mToM(parsed.month)}';
    }
    return !CommonUtil.isEnglishMode(context)
        ? '${parsed.year}年${parsed.month}月${parsed.day}号'
        : '${parsed.day} ${mToM(parsed.month)} ${parsed.year}';
  }

  static String mToM(int m){
    switch(m){
      case DateTime.january:
        return 'jan';
      case DateTime.february:
        return 'feb';
      case DateTime.march:
        return 'mar';
      case DateTime.april:
        return 'apr';
      case DateTime.may:
        return 'may';
      case DateTime.june:
        return 'jun';
      case DateTime.july:
        return 'jul';
      case DateTime.august:
        return 'aug';
      case DateTime.september:
        return 'sep';
      case DateTime.october:
        return 'oct';
      case DateTime.november:
        return 'nov';
      case DateTime.december:
        return 'dec';
      default:
        return '';
    }
  }

  static bool isSameHour(DateTime dateA, DateTime dateB) {
    return dateA?.year == dateB?.year &&
          dateA?.month == dateB?.month &&
          dateA?.day == dateB?.day &&
          dateA?.hour == dateB?.hour;
  }

  static bool isSameYear(DateTime dateA, DateTime dateB) {
    return dateA?.year == dateB?.year;
  }
}