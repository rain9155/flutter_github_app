
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class LocaleCubit extends Cubit<Locale>{

  LocaleCubit() : super(null){
    SharedPreferencesUtil.get(KEY_LOCALE).then((value){
      setLocale(value);
    });
  }

  String _localeType;

  Locale get locale {
    if(_localeType == null){
      return null;
    }
    if(_localeType == LAN_ENGLISH){
      return AppLocalizations.supportedLocales[1];
    }else{
      return AppLocalizations.supportedLocales[0];
    }
  }

  setLocale(String localeType) async{
    _localeType = localeType;
    SharedPreferencesUtil.setString(KEY_LOCALE, localeType);
    emit(locale);
  }

}