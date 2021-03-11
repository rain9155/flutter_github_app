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
      primary: Colors.white,
      primaryVariant: Colors.white,
      secondary: Color(0xff1976D2),
      secondaryVariant: Color(0xff1976D2),
      background: Color(0xffF5F5F5),
      surface: Colors.white,
      onSurface: Colors.black,
      onPrimary: Colors.black
    ),
  );

  static final ThemeData _dartTheme = ThemeData.from(
    colorScheme: ColorScheme.dark(
      primary: Colors.black,
      primaryVariant: Colors.black,
      secondary: Color(0xff1976D2),
      secondaryVariant: Color(0xff1976D2),
      background: Color(0xff212121),
      surface: Colors.black,
      onPrimary: Colors.white,
      onSurface: Colors.white
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
    SharedPreferencesUtil.setInt(KEY_THEME, _themeType);
    emit(theme);
  }
  
}