import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class ThemeCubit extends Cubit<ThemeData>{

  ThemeCubit() : super(_lightTheme){
    SharedPreferencesUtil.get(KEY_THEME).then((value){
      setTheme(value);
    });
  }

  static final ThemeData _lightTheme = ThemeData.from(
    colorScheme: ColorScheme.light(
        primary: Color(0xfffafafa),
        primaryVariant: Color(0xffc7c7c7),
        secondary: Colors.blue,
        secondaryVariant: Color(0xff0069c0),
        onPrimary: Color(0xff212121)
    ),
  );

  static final ThemeData _dartTheme = ThemeData.from(
    colorScheme: ColorScheme.dark(
        primary: Color(0xff212121),
        primaryVariant: Colors.black,
        secondary: Colors.blue,
        secondaryVariant: Color(0xff0069c0),
        onPrimary: Color(0xfffafafa)
    ),
  );

  int _themeType = THEME_LIGHT;
  
  ThemeData get theme {
    if(_themeType == THEME_DART){
      return _dartTheme;
    }else{
      return _lightTheme;
    }
  }
  
  setTheme(int themeType) async{
    _themeType = themeType;
    SharedPreferencesUtil.set(KEY_THEME, _themeType);
    emit(theme);
  }
  
}