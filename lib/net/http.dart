import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/interceptor/cache_interceptor.dart';
import 'file:///D:/File/source/Flutter/flutter_github_app/lib/net/interceptor/token_interceptor.dart';
import 'package:flutter_github_app/utils/log_util.dart';

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

  static const tag = 'HttpClient';

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
      connectTimeout: 180000,
      sendTimeout: 60000,
      receiveTimeout: 60000,
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      TokenInterceptor(),
      CacheInterceptor(),
    ]);
    if(DEBUG){
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client){
        client.findProxy = (uri){
          return 'PROXY 10.87.93.125:8888; DIRECT';
        };
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  Future<HttpResult> get(String url, {
    Map<String, dynamic> headers,
    Map<String, dynamic> params,
    Map<String, dynamic> extras,
    ResponseType responseType,
    CancelToken cancelToken
  }) async{
    return _request(
      url,
      method: 'GET',
      headers: headers,
      params: params,
      extras: extras,
      responseType: responseType,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> post(String url, {
    Map<String, dynamic> headers,
    datas,
    Map<String, dynamic> extras,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    ResponseType responseType,
    CancelToken cancelToken
  })async{
    return _request(
      url,
      method: 'POST',
      headers: headers,
      datas: datas,
      extras: extras,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      responseType: responseType,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> put(String url, {
    Map<String, dynamic> headers,
    datas,
    Map<String, dynamic> extras,
    ResponseType responseType,
    CancelToken cancelToken,
  }) async{
    return _request(
      url,
      method: 'PUT',
      headers: headers,
      datas: datas,
      extras: extras,
      responseType: responseType,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> delete(String url, {
    Map<String, dynamic> headers,
    Map<String, dynamic> extras,
    ResponseType responseType,
    CancelToken cancelToken
  }) async{
    return _request(
      url,
      method: 'DELETE',
      headers: headers,
      extras: extras,
      responseType: responseType,
      cancelToken: cancelToken
    );
  }

  Future<HttpResult> _request(
    String url, {
    String method,
    Map<String, dynamic> headers,
    datas,
    Map<String, dynamic> params,
    Map<String, dynamic> extras,
    ResponseType responseType,
    ProgressCallback onReceiveProgress,
    ProgressCallback onSendProgress,
    CancelToken cancelToken
  }) async {
    LogUtil.printString(HttpClient.tag, '_request: url = $url');
    try{
      Options options = Options(
        method: method,
        headers: headers,
        responseType: responseType,
        extra: extras,
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
    LogUtil.printString(HttpClient.tag, '_handleSuccess: data = ${response.data}');
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
    }else if(e.type == DioErrorType.DEFAULT){
      if(e.error is SocketException){
        OSError osError = (e.error as SocketException).osError;
        if(osError != null){
          if(osError.errorCode == 7){
            code = CODE_CONNECT_LOST;
          }
        }
      }
    }
    LogUtil.printString(HttpClient.tag, '_handleError: msg = $msg, code = $code');
    return HttpResult(headers, code, msg, null);
  }
}