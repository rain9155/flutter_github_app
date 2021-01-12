import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/user.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/http.dart';

class ApiResult{

  const ApiResult(
    this.data, 
    this.error, 
    this.isSuccess
  );
  
  final data;
  final error;
  final bool isSuccess;
  
}

class Api{

  static Api _instance;

  static Api getInstance(){
    if(_instance == null){
      _instance = Api._internal();
    }
    return _instance;
  }

  String _baseUrl;
  String _baseAuthUrl;
  Map<String, dynamic> _headers;
  
  Api._internal(){
    _baseUrl = 'https://api.github.com/';
    _baseAuthUrl = 'https://github.com/';
    _headers = {
      HttpHeaders.userAgentHeader : 'flutter_github_app',
      HttpHeaders.acceptHeader : 'application/vnd.github.v3+json',
    };
  }
  
  String _getUrl(String relativePath){
    return '$_baseUrl$relativePath';
  }

  String _getAuthUrl(String relativePath){
    return '$_baseAuthUrl$relativePath';
  }

  bool _isScopesVaild(String scopes){
    if(scopes == null || scopes.isEmpty){
      return false;
    }
    List<String> scopesNeeded = ['user', 'repo', 'notifications'];
    for(var scopeNeeded in scopesNeeded){
      if(!scopes.contains(scopeNeeded)){
        return false;
      }
    }
    return true;
  }

  void getVerifyCode({
    CompleteCallback onComplete,
    SuccessCallback onSuccess,
    ErrorCallback onError,
    CancelToken cancelToken
  }){
    String url = _getAuthUrl('login/device/code');
    var datas = {
      'client_id': CLIENT_ID,
      'scope': 'user repo notifications',
    };
    HttpClient.getInstance().post(
      url,
      headers: _headers,
      datas: jsonEncode(datas),
      cancelToken: cancelToken
    ).then((result){
      onComplete?.call();
      if(result.code == CODE_SUCCESS){
        VerifyCode verifyCode = VerifyCode.fromJson(result.data);
        onSuccess?.call(verifyCode);
      }else{
        onError?.call(result.code, result.msg);
      }
    });
  }

  void getAccessToken(String deviceCode, {
    CompleteCallback onComplete,
    SuccessCallback onSuccess,
    ErrorCallback onError,
    CancelToken cancelToken
  }){
    String url = _getAuthUrl('login/oauth/access_token');
    var datas = {
      'client_id': CLIENT_ID,
      'device_code': deviceCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code'
    };
    HttpClient.getInstance().post(
      url,
      headers: _headers,
      datas: jsonEncode(datas),
      cancelToken: cancelToken
    ).then((result) {
      onComplete?.call();
      if(result.code == CODE_SUCCESS){
        AccessToken accessToken = AccessToken.fromJson(result.data);
        if(accessToken.error == null){
          if(_isScopesVaild(accessToken.scope)){
            onSuccess?.call(accessToken.accessToken);
          }else{
            onError?.call(CODE_SCOPE_MISSING, MSG_SCOPE_MISSING);
          }
        }else{
          int code = CODE_TOKEN_ERROR;
          String msg = accessToken.error;
          switch(msg){
            case MSG_TOKEN_PENDING:
              code = CODE_TOKEN_PENDING;
              break;
            case MSG_TOKEN_SLOW_DOWN:
              code = CODE_TOKEN_SLOW_DOWN;
              break;
            case MSG_TOKEN_EXPIRE:
              code = CODE_TOKEN_EXPIRE;
              break;
            case MSG_TOKEN_DENIED:
              code = CODE_TOKEN_DENIED;
              break;
          }
          onError?.call(code, msg);
        }
      }else{
        onError?.call(result.code, result.msg);
      }
    });
  }

  void checkToken({
    CompleteCallback onComplete,
    SuccessCallback onSuccess,
    ErrorCallback onError,
    CancelToken cancelToken
  }){
    String url = _getUrl('user');
    HttpClient.getInstance().get(
        url,
        headers: _headers,
        cancelToken: cancelToken
    ).then((result){
      onComplete?.call();
      if(result.code == CODE_SUCCESS){
        List<String> scopes = result.headers['x-oauth-scopes'];
        if(scopes != null
            && scopes.isNotEmpty
            && _isScopesVaild(scopes[0])){
          onSuccess?.call('');
        }else{
          onError?.call(CODE_SCOPE_MISSING, MSG_SCOPE_MISSING);
        }
      }else{
        onError?.call(result.code, result.msg);
      }
    });
  }

  void getUser({
    CompleteCallback onComplete,
    SuccessCallback onSuccess,
    ErrorCallback onError,
    CancelToken cancelToken
  }){
    String url = _getUrl('user');
    HttpClient.getInstance().get(
      url,
      headers: _headers,
      cancelToken: cancelToken
    ).then((result){
      onComplete?.call();
      if(result.code == CODE_SUCCESS){
        User user = User.fromJson(jsonDecode(result.data));
        onSuccess?.call(user);
      }else{
        onError?.call(result.code, result.msg);
      }
    });
  }
}