import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class LocaleModel extends ChangeNotifier{

  String _locale;
  String get locale => _locale;

  LocaleModel(){
    SharedPreferencesUtil.get(KEY_LOCALE).then((value){
      _locale = value;
      notifyListeners();
    });
  }

  Locale getLocale(){
    if(_locale == null){
      return null;
    }
    List<String> splits = _locale.split(" ");
    return Locale(splits[0], splits[1]);
  }

}