import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  AuthenticationBloc() : super(AuthenticationInitialState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {

    if(event is AppStartedEvent){
      String token = await SharedPreferencesUtil.get(KEY_TOKEN);
      if(token != null){
        yield AuthenticatedState();
      }else{
        yield UnauthenticatedState();
      }
    }

    if(event is LoggedInEvent){
      SharedPreferencesUtil.set(KEY_TOKEN, event.token);
      yield AuthenticatedState();
    }

    if(event is LoggedOutEvent){
      SharedPreferencesUtil.remove(KEY_TOKEN);
      yield UnauthenticatedState();
    }
  }
}