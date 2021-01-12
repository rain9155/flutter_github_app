import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  LoginBloc(this.context, this.authenticationBloc) : super(LoginInitialState());

  final BuildContext context;
  final AuthenticationBloc authenticationBloc;
  final CancelToken cancelToken = CancelToken();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event,) async* {
    if(event is LoginButtonPressedEvent){
      yield LoginLoadingState();
      LoginState loginState = await _login();
      if(loginState is LoginFailureState){
        yield loginState;
      }else if(loginState is LoginSuccessState){
        authenticationBloc.add(LoggedInEvent(loginState.token));
      }
    }
  }

  Future<LoginState> _login() async{
    try{
      VerifyCode verifyCode = await Api.getInstance().getVerifyCode(cancelToken: cancelToken);
      var loginSuccess = await Navigator.of(context).pushNamed(
          WebViewRoute.name,
          arguments: verifyCode
      );
      if(!loginSuccess){
        return LoginFailureState(AppLocalizations.of(context).loginUnFinished);
      }else{
        return _getAccessToken(verifyCode);
      }
    }on ApiException catch(e){
      return LoginFailureState('${AppLocalizations.of(context).loginFail}: ${e.msg}');
    }
  }

  Future<LoginState> _getAccessToken(VerifyCode verifyCode) async{
    try{
      AccessToken token = await Api.getInstance().getAccessToken(
          verifyCode.deviceCode,
          cancelToken: cancelToken
      );
      return LoginSuccessState(token.accessToken);
    }on ApiException catch(e){
      if(e.code == CODE_TOKEN_PENDING){
        return Future.delayed(Duration(seconds: verifyCode.interval + 1), (){
          return _getAccessToken(verifyCode);
        });
      }else if(e.code == CODE_TOKEN_SLOW_DOWN){
        return Future.delayed(Duration(seconds: (verifyCode.interval + 1) * 2), (){
          return _getAccessToken(verifyCode);
        });
      }else{
        return LoginFailureState('${AppLocalizations.of(context).loginFail}: ${e.msg}');
      }
    }
  }

  @override
  Future<Function> close() {
    cancelToken.cancel('LoginBloc close');
    super.close();
  }

}
