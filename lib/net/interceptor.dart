
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

const TAG = 'TokenInterceptor';

class TokenInterceptor extends InterceptorsWrapper{

  String _token;

  @override
  Future onRequest(RequestOptions options) async{
    if(_token == null){
      _token = await SharedPreferencesUtil.get(KEY_TOKEN);
    }
    options.headers[HttpHeaders.authorizationHeader] = 'token $_token';
    return options;
  }

  @override
  Future onResponse(Response response) async{
    if(response.statusCode == HttpStatus.unauthorized){
      LogUtil.printString(TAG, 'TokenInterceptor onResponse: token revoked');
    }
    return response;
  }
}