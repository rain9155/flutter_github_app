import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class ThemeCubit extends Cubit<ThemeMode>{

  ThemeCubit() : super(ThemeMode.system){
    _init();
  }

  final ThemeData _lightTheme = ThemeData.from(
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

  final ThemeData _dartTheme = ThemeData.from(
    colorScheme: ColorScheme.dark(
        primary: Color(0xff212121),
        primaryVariant: Color(0xff212121),
        secondary: Colors.blueAccent,
        secondaryVariant: Colors.blueAccent,
        background: Colors.black,
        surface: Color(0xff212121),
        onPrimary: Colors.white,
        onSurface: Colors.white
    ),
  ).copyWith(
      applyElevationOverlayColor: false
  );

  ThemeData get lightTheme => _lightTheme;

  ThemeData get darkTheme => _dartTheme;

  ThemeMode get themeMode => state;

  void _init() {
    ThemeMode themeMode;
    if(AppConfig.theme == ThemeMode.light.index){
      themeMode = ThemeMode.light;
    }else if(AppConfig.theme == ThemeMode.dark.index){
      themeMode = ThemeMode.dark;
    }else{
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }

  bool setThemeMode(ThemeMode mode){
    if(mode != themeMode){
      SharedPreferencesUtil.setInt(KEY_THEME, mode.index);
      emit(mode);
      return true;
    }
    return false;
  }
  
}