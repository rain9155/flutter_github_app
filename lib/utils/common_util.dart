import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';

class CommonUtil{

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
      case CODE_UNKNOWN_ERROR:
        return AppLocalizations.of(context).unknownError;
      case CODE_TOKEN_DENIED:
        return AppLocalizations.of(context).tokenDenied;
      case CODE_TOKEN_EXPIRE:
      case HttpStatus.unauthorized:
        return AppLocalizations.of(context).tokenExpire;
      case CODE_TOKEN_ERROR:
        return AppLocalizations.of(context).tokenError;
      case CODE_SCOPE_MISSING:
        return AppLocalizations.of(context).tokenScopeMissing;
      default:
        return AppLocalizations.of(context).networkRequestError;
    }
  }

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

  static bool isTextEmpty(String text){
    return text == null || text.isEmpty;
  }

  static bool isListEmpty(List list){
    return list == null || list.isEmpty;
  }
}