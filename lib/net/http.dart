import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/debug.dart';
import 'package:flutter_github_app/net/interceptor/cache_interceptor.dart';
import 'package:flutter_github_app/net/interceptor/token_interceptor.dart';
import 'package:flutter_github_app/utils/log_util.dart';

class HttpResult{
  
  const HttpResult(
    this.headers,
    this.code,
    this.msg,
    this.data
  );

  final Headers? headers;
  final int? code;
  final String msg;
  final data;
}

/// http请求实现类
class HttpClient {

  static const tag = 'HttpClient';

  static HttpClient? _instance;

  static HttpClient getInstance(){
    if(_instance == null){
      _instance = HttpClient._internal();
    }
    return _instance!;
  }

  late Dio _dio;

  HttpClient._internal() {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: const Duration(milliseconds: 180000),
      sendTimeout: const Duration(milliseconds: 60000),
      receiveTimeout: const Duration(milliseconds: 60000),
    );
    _dio = Dio(baseOptions);
    _dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      TokenInterceptor(),
      CacheInterceptor(),
    ]);
    if(DEBUG){
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = createDioHttpClient;
    }
  }

  Future<HttpResult> get(String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    Map<String, dynamic>? extras,
    ResponseType? responseType,
    CancelToken? cancelToken
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
    Map<String, dynamic>? headers,
    datas,
    Map<String, dynamic>? extras,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    ResponseType? responseType,
    CancelToken? cancelToken
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
    Map<String, dynamic>? headers,
    datas,
    Map<String, dynamic>? extras,
    ResponseType? responseType,
    CancelToken? cancelToken,
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
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extras,
    ResponseType? responseType,
    CancelToken? cancelToken
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
    String? method,
    Map<String, dynamic>? headers,
    datas,
    Map<String, dynamic>? params,
    Map<String, dynamic>? extras,
    ResponseType? responseType,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken
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
    }on DioException catch(e){
      return _handleError(e);
    }
  }

  Future<HttpResult> _handleSuccess(Response response) async {
    LogUtil.printString(HttpClient.tag, '_handleSuccess: data = ${response.data}');
    return HttpResult(response.headers, CODE_SUCCESS, '', response.data);
  }

  Future<HttpResult> _handleError(DioException e) async{
    String msg = e.toString();
    int? code = CODE_UNKNOWN_ERROR;
    Headers? headers;
    if(e.type == DioExceptionType.badResponse){
      code = e.response!.statusCode;
      headers = e.response!.headers;
    }else if(e.type == DioExceptionType.connectionTimeout
        || e.type == DioExceptionType.receiveTimeout
        || e.type == DioExceptionType.sendTimeout){
      code = CODE_CONNECT_TIMEOUT;
    }else if(e.type == DioExceptionType.cancel){
      code = CODE_REQUEST_CANCEL;
    }else if(e.type == DioExceptionType.unknown){
      if(e.error is SocketException){
        OSError? osError = (e.error as SocketException).osError;
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