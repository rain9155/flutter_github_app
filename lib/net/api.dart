import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/token.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/http.dart';

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
      'User-Agent': 'flutter_github_app',
      'Accept': 'application/vnd.github.v3+json'
    };
  }
  
  String _getUrl(String relativePath){
    return '$_baseUrl$relativePath';
  }

  String _getAuthUrl(String relativePath){
    return '$_baseAuthUrl$relativePath';
  }

  void getVerifyCode({
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
      if(result.code == CODE_SUCCESS){
        if(onSuccess != null){
          VerifyCode verifyCode = VerifyCode.fromJson(result.data);
          onSuccess(verifyCode);
        }
      }else{
        if(onError != null){
          onError(result.code, result.msg);
        }
      }
    });
  }

  void getAccessToken(String deviceCode, {
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
      if(result.code == CODE_SUCCESS){
        AccessToken accessToken = AccessToken.fromJson(result.data);
        if(accessToken.error == null){
          if(onSuccess != null){
            onSuccess(accessToken.accessToken);
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
          if(onError != null){
            onError(code, msg);
          }
        }
      }else{
        if(onError != null){
          onError(result.code, result.msg);
        }
      }
    });
  }

  void checkToken(String accessToken, {
    SuccessCallback onSuccess,
    ErrorCallback onError,
    CancelToken cancelToken
  }){
    String url = _getUrl('applications/$CLIENT_ID/token');
    var datas = {
      'access_token': accessToken
    };
    HttpClient.getInstance().post(
      url,
      headers: _headers,
      datas: jsonEncode(datas),
      cancelToken: cancelToken
    ).then((result){
        if(result.code == CODE_SUCCESS){
          Token token = Token.fromJson(result.data);
          List<String> scopeIncluded = ['user', 'repo', 'notifications'];
          if(token.scopes == null
              || !scopeIncluded.every((element) => token.scopes.contains(element))){
            if(onError != null){
              onError(CODE_SCOPE_MISSING, '');
            }
          }else{
            if(onSuccess != null){
              onSuccess(token.token);
            }
          }
        }else{
          if(onError != null){
            onError(result.code, result.msg);
          }
        }
    });
  }

}