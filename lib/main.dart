
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/app.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

class SimpleBlocObserver extends BlocObserver{

  static final tag = 'SimpleBlocObserver';

  @override
  void onCreate(BlocBase bloc) {
    LogUtil.printString(tag, 'onCreate: bloc = $bloc');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    LogUtil.printString(tag, 'onEvent: event = $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    LogUtil.printString(tag, 'onChange: change = $change');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    LogUtil.printString(tag, 'onTransition: transition = $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    LogUtil.printString(tag, 'onError: error = $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    LogUtil.printString(tag, 'onClose: bloc = $bloc');
    super.onClose(bloc);
  }
}

class AppConfig{

  static int theme;

  static int locale;

  static String name;

  static Future init() async{
    Bloc.observer = SimpleBlocObserver();
    WidgetsFlutterBinding.ensureInitialized();
    theme = await SharedPreferencesUtil.get(KEY_THEME);
    locale = await SharedPreferencesUtil.get(KEY_LOCALE);
    name = await SharedPreferencesUtil.get(KEY_NAME);
  }
}

void main() {
  AppConfig.init().then((_) => runApp(MyApp.route()));
}



