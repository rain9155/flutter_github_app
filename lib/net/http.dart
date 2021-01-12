import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/interceptor.dart';

class HttpResult{
  
  const HttpResult(
    this.headers,
    this.code,
    this.msg,
    this.data
  );

  final Headers headers;
  final int code;
  final String msg;
  final data;
}

/// http请求实现类
class HttpClient {

  static HttpClient _instance;

  static HttpClient getInstance(){
    if(_instance == null){
      _instance = HttpClient._internal();
    }
    return _instance;
  }

  Dio _dio;

  HttpClient._internal() {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: 5000,
      sendTimeout: 5000,
      receiveTimeout: 10000
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(TokenInterceptor());
    if(DEBUG){
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
        client.findProxy = (uri){
          return 'PROXY 10.87.93.125:8888; DIRECT';
        };
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<HttpResult> get(
    String url, {
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    CancelToken cancelToken
  })async{
    return _request(
      url,
      method: 'GET',
      headers: headers,
      params: params,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> post(
    String url, {
    Map<String, dynamic> headers,
    datas,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    CancelToken cancelToken
  })async{
    return _request(
      url,
      method: 'POST',
      headers: headers,
      datas: datas,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> _request(
    String url, {
    String method,
    Map<String, dynamic> headers,
    datas,
    Map<String, dynamic> params,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    CancelToken cancelToken
  }) async {
    debugPrint('HttpClient request: url = $url');
    try{
      Options options = Options(
        method: method,
        headers: headers,
        responseType: ResponseType.json
      );
      Response response = await _dio.request(
        url,
        data: datas,
        queryParameters: params,
        options: options,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken
      );
      return _handleSuccess(response);
    }on DioError catch(e){
      return _handleError(e);
    }
  }

  Future<HttpResult> _handleSuccess(Response response) async {
    debugPrint('HttpClient success: data = ${response.data}');
    return HttpResult(response.headers, CODE_SUCCESS, '', response.data);
  }

  Future<HttpResult> _handleError(DioError e) async{
    String msg = e.toString();
    int code = CODE_UNKNOWN_ERROR;
    Headers headers;
    if(e.type == DioErrorType.RESPONSE){
      code = e.response.statusCode;
      headers = e.response.headers;
    }else if(e.type == DioErrorType.CONNECT_TIMEOUT
        || e.type == DioErrorType.RECEIVE_TIMEOUT
        || e.type == DioErrorType.SEND_TIMEOUT){
      code = CODE_CONNECT_TIMEOUT;
    }else if(e.type == DioErrorType.CANCEL){
      code = CODE_REQUEST_CANCEL;
    }
    debugPrint('HttpClient error: msg = $msg, code = $code');
    return HttpResult(headers, code, msg, null);
  }
}