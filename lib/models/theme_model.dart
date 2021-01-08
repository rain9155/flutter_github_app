import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class ThemeModel extends ChangeNotifier{

  int _theme;
  int get theme => _theme;

  ThemeModel(){
    SharedPreferencesUtil.get(KEY_THEME).then((value){
      _theme = value;
      notifyListeners();
    });
  }

  ThemeData getTheme(){
    if(_theme == THEME_DART){
      return ThemeData.from(
        colorScheme: ColorScheme.dark(
          primary: Color(0xff212121),
          primaryVariant: Colors.black,
          secondary: Colors.blue,
          secondaryVariant: Color(0xff0069c0),
          onPrimary: Color(0xfffafafa)
        ),
      );
    }else{
      return ThemeData.from(
        colorScheme: ColorScheme.light(
          primary: Color(0xfffafafa),
          primaryVariant: Color(0xffc7c7c7),
          secondary: Colors.blue,
          secondaryVariant: Color(0xff0069c0),
          onPrimary: Color(0xff212121)
        ),
      );
    }
  }

}