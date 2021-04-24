import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/theme_cubit.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'dart:math' as math;

class CommonUtil{

  CommonUtil._();

  static String getActionByEvent(BuildContext context, Event event, [bool includeActor = true]){
    if(event == null || isTextEmpty(event.type)){
      return '';
    }
    String actor(){
      if(includeActor){
        return event.actor.login + ' ';
      }
      return '';
    }
    String repo = event.repo.name;
    String subType = event.type.replaceAll('Event', '');
    try{
      switch(event.type){
        case 'CreateEvent':
          return '${actor()}created a ${event.payload['ref_type']} $repo';
        case 'DeleteEvent':
          return '${actor()}deleted a ${event.payload['ref_type']} $repo';
        case 'ForkEvent':
          return '${actor()}forked ${event.payload['forkee']['full_name']} from $repo';
        case 'IssuesEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} a issue on $repo';
        case 'IssueCommentEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} a issue comment on $repo';
        case 'PublicEvent':
          return '${actor()}made $repo public';
        case 'PullRequestEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} a pullRequest on $repo';
        case 'PullRequestReviewCommentEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} a pullRequest comment on $repo';
        case 'PushEvent':
          return '${actor()}pushed ${event.payload['size']} commits on $repo';
        case 'ReleaseEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} a release on $repo';
        case 'WatchEvent':
          return '${actor()}${removeUnderline(event.payload['action'])} $repo';
        case 'CommitCommentEvent':
          return '${actor()}commented commits on $repo';
        default:
          return '${actor()}${changeFirstChar(subType)} $repo';
      }
    }catch(e){
      return '${actor()}${changeFirstChar(subType)} $repo';
    }
  }

  static String changeFirstChar(String str, [bool upperCase = false]){
    if(isTextEmpty(str)){
      return '';
    }
    if(upperCase){
      return str.substring(0, 1).toUpperCase() + str.substring(1);
    }else{
      return str.substring(0, 1).toLowerCase() + str.substring(1);
    }
  }

  static String removeUnderline(String str){
    if(isTextEmpty(str)){
      return '';
    }
    List<String> splits = str.split('_');
    StringBuffer string = StringBuffer(splits[0]);
    for(int i = 1;  i < splits.length; i++){
      string.write(changeFirstChar(splits[i], true));
    }
    return string.toString();
  }

  static String getErrorMsgByCode(BuildContext context, int code){
    if(code == CODE_SUCCESS){
      return '';
    }
    switch(code){
      case CODE_CONNECT_TIMEOUT:
        return AppLocalizations.of(context).networkConnectTimeout;
      case CODE_CONNECT_LOST:
        return AppLocalizations.of(context).networkConnectLost;
      case CODE_REQUEST_CANCEL:
        return AppLocalizations.of(context).networkRequestCancel;
      case HttpStatus.forbidden:
        return AppLocalizations.of(context).networkRequestLimitExceeded;
      case HttpStatus.unprocessableEntity:
        return AppLocalizations.of(context).networkRequestValidationFailed;
      case HttpStatus.gone:
        return AppLocalizations.of(context).featureTurnOff;
      case CODE_UNKNOWN_ERROR:
        return AppLocalizations.of(context).unknownError;
      case CODE_TOKEN_EXPIRE:
      case HttpStatus.unauthorized:
        return AppLocalizations.of(context).tokenExpire;
      case CODE_TOKEN_DENIED:
        return AppLocalizations.of(context).tokenDenied;
      case CODE_TOKEN_ERROR:
        return AppLocalizations.of(context).tokenError;
      case CODE_SCOPE_MISSING:
        return AppLocalizations.of(context).tokenScopeMissing;
      case CODE_AUTH_UNFINISHED:
        return AppLocalizations.of(context).authUnFinished;
      default:
        return AppLocalizations.of(context).networkRequestError;
    }
  }

  static String numToThousand(int num){
    if(num== null){
      return '';
    }
    if(num < 1000){
      return num.toString();
    }
    try{
      int rest = num % 1000;
      if(rest == 0){
        return '${num / 1000}k';
      }else{
        return '${(num / 1000.0).toStringAsFixed(1)}k';
      }
    }catch(e){
      return num.toString();
    }
  }


  static bool isTextEmpty(String text){
    return text == null || text.isEmpty;
  }

  static bool isListEmpty(List list){
    return list == null || list.isEmpty;
  }

  static bool isImgEng(String path){
    bool isImg = false;
    [".png", ".jpg", ".jpeg", ".gif", ".svg"].forEach((element) {
      if(path.endsWith(element)){
        isImg = true;
      }
    });
    return isImg;
  }

  static String getFileName(String path){
    String fileName;
    try{
      fileName = path.substring(path.lastIndexOf('/') + 1);
    }catch(e){
      fileName = path;
    }
    return fileName;
  }

   static bool isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  static setSystemUIColor(bool isDarkMode){
    SystemChrome.setSystemUIOverlayStyle(getSystemUIStyle(isDarkMode));
  }

  static SystemUiOverlayStyle getSystemUIStyle(bool isDarkMode){
    return isDarkMode
      ? SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: colorWithOverlay(Color(0xff212121), Colors.white, elevation: 8)
      )
      : SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white
      );
  }
  
  static setEnabledSystemUI({
    bool top = true,
    bool bottom = true,
  }){
    List<SystemUiOverlay> overlays;
    if(top && bottom){
      overlays = [SystemUiOverlay.top, SystemUiOverlay.bottom];
    }else if(top){
      overlays = [SystemUiOverlay.top];
    }else if(bottom){
      overlays = [SystemUiOverlay.bottom];
    }else{
      overlays = [];
    }
    SystemChrome.setEnabledSystemUIOverlays(overlays);
  }

  static Color colorWithOverlay(Color color, Color overlayColor, {double elevation}){
    if(elevation != null && elevation > 0){
      overlayColor = overlayColor.withOpacity((4.5 * math.log(elevation + 1) + 2) / 100.0);
    }
    return Color.alphaBlend(overlayColor, color);
  }

  static bool isEnglishMode(BuildContext context){
    Locale locale = AppLocalizations.ofLocale(context);
    return locale.languageCode == LAN_ENGLISH;
  }
}