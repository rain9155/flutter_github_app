import 'dart:async';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'base.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends BaseBloc<AuthenticationEvent, AuthenticationState> {

  static const tag = "AuthenticationBloc";

  AuthenticationBloc() : super(AuthenticationInitialState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStartedEvent){
      String token = await SharedPreferencesUtil.get(KEY_TOKEN);
      if(token != null){
        LogUtil.printString(tag, "mapEventToState: token = $token");
        //todo: hard code
        //bool isValid = await Api.getInstance().checkToken(cancelToken: cancelToken);
        if(true){
          yield AuthenticatedState();
        }else{
          yield UnauthenticatedState();
        }
      }else{
        yield UnauthenticatedState();
      }
    }

    if(event is LoggedInEvent){
      LogUtil.printString(tag, "mapEventToState: token = ${event.token}");
      SharedPreferencesUtil.setString(KEY_TOKEN, event.token);
      yield AuthenticatedState();
    }

    if(event is LoggedOutEvent){
      SharedPreferencesUtil.remove(KEY_TOKEN);
      yield UnauthenticatedState();
    }
  }
}
