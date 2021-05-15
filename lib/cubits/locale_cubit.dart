
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

enum LocaleMode{
  chinese,

  english,

  system
}

class LocaleCubit extends Cubit<LocaleMode>{

  LocaleCubit() : super(LocaleMode.system){
    _init();
  }

  LocaleMode get localeMode => state;

  void _init() {
    LocaleMode localeMode;
    if(AppConfig.locale == LocaleMode.chinese.index){
      localeMode = LocaleMode.chinese;
    }else if(AppConfig.locale == LocaleMode.english.index){
      localeMode = LocaleMode.english;
    }else{
      localeMode = LocaleMode.system;
    }
    setLocaleMode(localeMode);
  }

  bool setLocaleMode(LocaleMode mode){
    if(mode != localeMode){
      SharedPreferencesUtil.setInt(KEY_LOCALE, mode.index);
      emit(mode);
      return true;
    }
    return false;
  }
}