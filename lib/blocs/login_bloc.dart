import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      _login();
    }

    if(event is LoginFailureEvent){
      yield LoginFailureState(event.error);
    }

    if(event is LoginSuccessEvent){
      authenticationBloc.add(LoggedInEvent(event.token));
    }
  }

  void _login() {
    Api.getInstance().getVerifyCode(
        onSuccess: (data) async{
          VerifyCode verifyCode = data;
          Navigator.of(context).pushNamed(
              WebViewRoute.name,
              arguments: verifyCode
          ).then((value){
            bool loginSuccess = value;
            if(!loginSuccess){
              add(LoginFailureEvent(AppLocalizations.of(context).loginUnFinished));
            }else{
              _getAccessToken(verifyCode);
            }
          });
        },
        onError: (code, msg){
          add(LoginFailureEvent('${AppLocalizations.of(context).loginFail}: $msg'));
        },
        cancelToken: cancelToken
    );
  }

  void _getAccessToken(VerifyCode verifyCode) {
    Api.getInstance().getAccessToken(
        verifyCode.deviceCode,
        onSuccess: (token){
          add(LoginSuccessEvent(token));
        },
        onError: (code, msg){
          if(code == CODE_TOKEN_PENDING){
            Future.delayed(Duration(seconds: verifyCode.interval + 1), (){
              _getAccessToken(verifyCode);
            });
          }else{
            add(LoginFailureEvent('${AppLocalizations.of(context).loginFail}: $msg'));
          }
        },
        cancelToken: cancelToken
    );
  }

  @override
  Future<Function> close() {
    cancelToken.cancel('LoginBloc close');
    super.close();
  }
}
