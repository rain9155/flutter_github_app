import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/notification.dart';
import 'package:flutter_github_app/beans/user.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/http.dart';

class ApiException implements Exception{

  ApiException({
    this.code,
    this.msg
  });

  final String msg;
  final int code;

  @override
  String toString() {
    return 'ApiException[code = $code, msg = $msg]';
  }
}

class Api{

  static const tag = 'Api';

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
  
  String _baseUrlAppendWith(String relativePath, {
    Map<String, dynamic> queries
  }){
    StringBuffer url = StringBuffer('$_baseUrl$relativePath');
    if(queries != null && queries.isNotEmpty){
      url.write('?');
      int i = 0;
      queries.forEach((key, value) {
        url.write('$key=$value');
        if(i != queries.length - 1){
          url.write('&');
        }
        i++;
      });
    }
    return url.toString();
  }

  String _baseAuthUrlAppendWith(String relativePath){
    return '$_baseAuthUrl$relativePath';
  }

  bool _isScopesValid(String scopes){
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

  /// 获取userCode和verifyUrl
  Future<VerifyCode> getVerifyCode({
    CancelToken cancelToken
  }) async{
    String url = _baseAuthUrlAppendWith('login/device/code');
    var datas = {
      'client_id': CLIENT_ID,
      'scope': 'user repo notifications',
    };
    HttpResult result = await HttpClient.getInstance().post(
      url,
      headers: _headers,
      datas: jsonEncode(datas)
    );
    if(result.code == CODE_SUCCESS){
      VerifyCode verifyCode = VerifyCode.fromJson(result.data);
      return verifyCode;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取accessToken
  Future<AccessToken> getAccessToken(String deviceCode, {
    CancelToken cancelToken
  }) async{
    String url = _baseAuthUrlAppendWith('login/oauth/access_token');
    var datas = {
      'client_id': CLIENT_ID,
      'device_code': deviceCode,
      'grant_type': 'urn:ietf:params:oauth:grant-type:device_code'
    };
    HttpResult result = await HttpClient.getInstance().post(
      url,
      headers: _headers,
      datas: jsonEncode(datas),
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      AccessToken accessToken = AccessToken.fromJson(result.data);
      if(accessToken.error == null){
        if(_isScopesValid(accessToken.scope)){
          return accessToken;
        }else{
          throw ApiException(code: CODE_SCOPE_MISSING, msg: MSG_SCOPE_MISSING);
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
        throw ApiException(code: code, msg: msg);
      }
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 检查token是否失效
  Future<bool> checkToken({
    CancelToken cancelToken
  }) async{
    String url = _baseUrlAppendWith('user');
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List<String> scopes = result.headers['x-oauth-scopes'];
      return scopes != null 
          && scopes.isNotEmpty
          && _isScopesValid(scopes[0]);
    }else{
      return false;
    }
  }

  /// 获取已登陆的用户信息
  Future<User> getUser({
    CancelToken cancelToken
  }) async{
    String url = _baseUrlAppendWith('user');
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      User user = User.fromJson(result.data);
      return user;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取授权用户因 watching repos 和 following users 而接收到的事件，不同EventType的payload不同，参考：
  /// https://docs.github.com/en/developers/webhooks-and-events/github-event-types
  Future<List<Event>> getReceivedEvents(String userName, {
    int perPage = -1,
    int page = -1,
    CancelToken cancelToken
  }) async{
    String url = _baseUrlAppendWith("users/$userName/received_events");
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Event> receivedEvents = [];
      datas.forEach((element) {
        receivedEvents.add(Event.fromJson(element));
      });
      return receivedEvents;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取授权用户触发的事件
  Future<List<Event>> getUserEvents(String userName, {
    int perPage = -1,
    int page = -1,
    CancelToken cancelToken
  }) async{
    String url = _baseUrlAppendWith('users/$userName/events');
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Event> events = [];
      datas.forEach((element) {
        events.add(Event.fromJson(element));
      });
      return events;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取授权用户接收的通知
  Future<List<Notification>> getNotifications({
    bool all = true,
    int perPage = -1,
    int page = -1,
    CancelToken cancelToken
  }) async{
    String url = _baseUrlAppendWith('notifications');
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        'all': all,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Notification> notifications = [];
      datas.forEach((element) {
        notifications.add(Notification.fromJson(element));
      });
      return notifications;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }


}