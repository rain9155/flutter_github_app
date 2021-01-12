import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/app.dart';
import 'package:flutter_github_app/utils/log_util.dart';

const TAG = 'main';

class SimpleBlocObserver extends BlocObserver{

  @override
  void onEvent(Bloc bloc, Object event) {
    LogUtil.printString(TAG, 'onEvent: event = $event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    LogUtil.printString(TAG, 'onChange: change = $change');
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    LogUtil.printString(TAG, 'onTransition: transition = $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    LogUtil.printString(TAG, 'onError: error = $error');
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onClose(Cubit cubit) {
    LogUtil.printString(TAG, 'onClose: cubit = $cubit');
    super.onClose(cubit);
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp.route());
}



