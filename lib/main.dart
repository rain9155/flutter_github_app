
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/app.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class SimpleBlocObserver extends BlocObserver{

  static const tag = 'SimpleBlocObserver';

  @override
  void onEvent(Bloc bloc, Object event) {
    LogUtil.printString(tag, 'onEvent: event = $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    LogUtil.printString(tag, 'onChange: change = $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    LogUtil.printString(tag, 'onTransition: transition = $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    LogUtil.printString(tag, 'onError: error = $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onClose(Cubit cubit) {
    LogUtil.printString(tag, 'onClose: cubit = $cubit');
    super.onClose(cubit);
  }
}

class AppConfig{

  static int themeType;

  static String localeType;

  static String name;

  static bool enableCache;

  static Future init() async{
    Bloc.observer = SimpleBlocObserver();
    WidgetsFlutterBinding.ensureInitialized();
    themeType = await SharedPreferencesUtil.get(KEY_THEME);
    localeType = await SharedPreferencesUtil.get(KEY_LOCALE);
    name = await SharedPreferencesUtil.get(KEY_NAME);
    enableCache = await SharedPreferencesUtil.getBool(KEY_ENABLE_CACHE, defaultValue: true);
  }

}

void main() {
  AppConfig.init().then((value) => runApp(MyApp.route()));
}



