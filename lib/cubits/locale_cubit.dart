
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class LocaleCubit extends Cubit<Locale>{

  LocaleCubit() : super(null){
    setLocale(AppConfig.localeType);
  }

  String localeType;

  Locale get locale {
    if(localeType == LAN_ENGLISH){
      return AppLocalizations.supportedLocales[1];
    }else{
      return AppLocalizations.defaultLocale;
    }
  }

  setLocale(String type) async{
    if(type == null){
      type = LAN_CHINESE;
    }
    localeType = type;
    SharedPreferencesUtil.setString(KEY_LOCALE, type);
    emit(locale);
  }

}