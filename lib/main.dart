import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/app.dart';
import 'package:flutter_github_app/utils/log_util.dart';

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

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp.route());
}



