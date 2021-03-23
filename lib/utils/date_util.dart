import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

class DateUtil{

  static String parseTime(BuildContext context, String formattedTime){
    DateTime now = DateTime.now();
    DateTime parsed = DateTime.parse(formattedTime);
    if(now.isBefore(parsed)){
      return '';
    }
    Duration diff = now.difference(parsed);
    if(isSameHour(now, parsed)){
      return AppLocalizations.of(context).just;
    }
    if(DateUtils.isSameDay(now, parsed)){
      return '${diff.inHours}${AppLocalizations.of(context).hoursAgo}';
    }
    if(DateUtils.isSameMonth(now, parsed)){
      return '${diff.inDays}${AppLocalizations.of(context).daysAgo}';
    }
    if(isSameYear(now, parsed)){
      return AppLocalizations.ofLocale(context).languageCode == LAN_CHINESE
          ? '${parsed.month}月${parsed.day}号'
          : '${parsed.day} ${mToM(parsed.month)}';
    }
    return AppLocalizations.ofLocale(context).languageCode == LAN_CHINESE
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