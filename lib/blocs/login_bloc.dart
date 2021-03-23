import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/device_code.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/routes/login_webview_route.dart';
import 'package:meta/meta.dart';
import '../mixin/bloc_mixin.dart';

part 'events/login_event.dart';
part 'states/login_state.dart';

/// Device flow授权方式，参考：
/// https://docs.github.com/en/developers/apps/authorizing-oauth-apps#device-flow
class LoginBloc extends Bloc<LoginEvent, LoginState> with BlocMixin{

  static const tag = 'LoginBloc';

  LoginBloc(this.context, this.authenticationBloc) : super(LoginInitialState());

  final BuildContext context;
  final AuthenticationBloc authenticationBloc;
  DeviceCode _deviceCode;
  DateTime _lastReceivedCodeTime;
  bool _authorized;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
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
    return await runBlockCaught(() async{
      if(_deviceCode == null
          || DateTime.now().difference(_lastReceivedCodeTime) > Duration(seconds: _deviceCode.expiresIn)
      ){
        //deviceCode未请求或过期，需要重新请求
        _deviceCode = await Api.getInstance().getDeviceCode(cancelToken: cancelToken);
        _lastReceivedCodeTime = DateTime.now();
        _authorized = null;
      }
      if(_authorized == null || !_authorized){
        //还未授权或之前授权失败，需要重新授权
        _authorized = await LoginWebViewRoute.push(context, deviceCode: _deviceCode);
      }
      if(!_authorized){
        return LoginFailureState(CODE_AUTH_UNFINISHED);
      }else{
        //授权成功后请求token
        return _getAccessToken(_deviceCode);
      }
    }, onError: (code, msg){
      return LoginFailureState(code);
    });
  }

  Future<LoginState> _getAccessToken(DeviceCode deviceCode) async{
    return await runBlockCaught(() async{
      AccessToken token = await Api.getInstance().getAccessToken(
          deviceCode.deviceCode,
          cancelToken: cancelToken
      );
      return LoginSuccessState(token.accessToken);
    }, onError: (code, msg){
      if(code == CODE_TOKEN_PENDING){
        return Future.delayed(Duration(seconds: deviceCode.interval + 1), (){
          return _getAccessToken(deviceCode);
        });
      }else if(code == CODE_TOKEN_SLOW_DOWN){
        return Future.delayed(Duration(seconds: (deviceCode.interval + 1) * 2), (){
          return _getAccessToken(deviceCode);
        });
      }else{
        return LoginFailureState(code);
      }
    });
  }

}
