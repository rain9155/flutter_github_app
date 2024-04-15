
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';


class TokenInterceptor extends InterceptorsWrapper{

  static const tag = 'TokenInterceptor';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    String? token = await SharedPreferencesUtil.get(KEY_TOKEN);
    options.headers[HttpHeaders.authorizationHeader] = 'token $token';
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async{
    if(response.statusCode == HttpStatus.unauthorized){
      LogUtil.printString(tag, 'TokenInterceptor onResponse: token revoked');
    }
    return super.onResponse(response, handler);
  }
}