import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class ThemeCubit extends Cubit<ThemeData>{

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
      primary: Color(0xff212121),
      primaryVariant: Color(0xff212121),
      secondary: Color(0xff1976D2),
      secondaryVariant: Color(0xff1976D2),
      background: Colors.black,
      surface: Color(0xff212121),
      onPrimary: Colors.white,
      onSurface: Colors.white
    ),
  );

  ThemeCubit() : super(null){
    setTheme(AppConfig.themeType);
  }

  int themeType;

  ThemeData get theme {
    if(themeType == THEME_DART){
      return _dartTheme;
    }else{
      return _lightTheme;
    }
  }
  
  setTheme(int type) async{
    if(type == null){
      type = THEME_LIGHT;
    }
    themeType = type;
    SharedPreferencesUtil.setInt(KEY_THEME, type);
    emit(theme);
  }
  
}