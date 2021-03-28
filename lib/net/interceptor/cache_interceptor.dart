import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/db/db_helper.dart';
import 'package:flutter_github_app/main.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:sqflite/sqflite.dart';

const MAX_CACHE_COUNT = 100; //100条请求
const MAX_CACHE_DATE = 1000 * 60 * 60 * 24; //24小时

class ResponseCacheObject{

  ResponseCacheObject(
    this.key,
    this.statusCode,
    this.headers,
    this.body, {
    int timeStamp
  }): this.timeStamp = timeStamp?? DateTime.now().millisecondsSinceEpoch;

  final int timeStamp;

  final String key;

  final int statusCode;

  final String headers;

  final List<int> body;

  @override
  String toString() {
    return 'CacheObject[key = $key, timeStamp = $timeStamp, statusCode = $statusCode, headers = $headers, body = $body]';
  }
}

class MemoryCache{

  LinkedHashMap<String, ResponseCacheObject> _cache = LinkedHashMap();

  put(ResponseCacheObject cacheObject){
    if(_cache.length >= MAX_CACHE_COUNT){
      remove(_cache.keys.first);
    }
    _cache[cacheObject.key] = cacheObject;
  }

  get(String key){
    return _cache[key];
  }

  remove(String key){
    _cache.remove(key);
  }

  removeContain(String subKey){
    _cache.removeWhere((k, v) => k.contains(subKey));
  }

  removeAll(){
    if(_cache.length > 0){
      _cache.clear();
    }
  }
}

class DiskCache{

  static final tag = 'DiskCache';

  final String _tableName = 'NetCache';
  final String _colKey = 'key';
  final String _colTimeStamp = 'timeStamp';
  final String _colStatusCode = 'statusCode';
  final String _colHeaders = 'headers';
  final String _colBody = 'body';

  bool _isTableCreated = false;
  int _cachedCount;

  Future _createTable() async{
    if(!_isTableCreated){
      await DBHelper.getInstance().execute('''
        CREATE TABLE IF NOT EXISTS $_tableName (
          $_colKey text primary key,
          $_colTimeStamp integer not null,
          $_colStatusCode integer,
          $_colHeaders text,
          $_colBody BLOB
        )
      ''');
      _isTableCreated = true;
    }
  }

  Future _getCachedCount() async{
    if(_cachedCount == null){
      _cachedCount = (await DBHelper.getInstance().query(_tableName)).length;
    }
  }

  Future put(ResponseCacheObject cacheObject) async{
    await _createTable();
    await _getCachedCount();
    if(_cachedCount >= MAX_CACHE_COUNT){
      int count = await DBHelper.getInstance().delete(
          _tableName,
          where: '$_colTimeStamp = (select min($_colTimeStamp) from $_tableName)',
      );
      _cachedCount -= count;
    }
    await DBHelper.getInstance().insert(_tableName, {
      _colKey: cacheObject.key,
      _colTimeStamp: cacheObject.timeStamp,
      _colStatusCode: cacheObject.statusCode,
      _colHeaders: cacheObject.headers,
      _colBody: cacheObject.body
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    _cachedCount += 1;
    LogUtil.printString(tag, 'put: cachedCount = $_cachedCount');
  }

  Future<ResponseCacheObject> get(String key) async{
    await _createTable();
    List<Map<String, Object>> results = await DBHelper.getInstance().query(
        _tableName,
        where: '$_colKey = ?',
        whereArgs: [key],
        limit: 1
    );
    if(CommonUtil.isListEmpty(results)){
      return null;
    }
    Map<String, Object> result = results[0];
    return ResponseCacheObject(
      result[_colKey],
      result[_colStatusCode],
      result[_colHeaders],
      result[_colBody],
      timeStamp: result[_colTimeStamp]
    );
  }

  Future remove(String key) async{
    await _getCachedCount();
    int count = await DBHelper.getInstance().delete(
        _tableName,
        where: '$_colKey = ?',
        whereArgs: [key]
    );
    _cachedCount -= count;
  }

  Future removeContain(String subKey) async{
    await _getCachedCount();
    int count = await DBHelper.getInstance().delete(
      _tableName,
      where: '$_colKey like ?',
      whereArgs: ['%$subKey%']
    );
    _cachedCount -= count;
  }

  Future removeAll() async{
    if(_isTableCreated && _cachedCount != null){
      await DBHelper.getInstance().delete(_tableName);
      _isTableCreated = false;
      _cachedCount = null;
    }
  }
}

class CacheInterceptor extends InterceptorsWrapper{

  static final tag = 'CacheInterceptor';

  MemoryCache _memoryCache = MemoryCache();
  DiskCache _diskCache = DiskCache();

  @override
  Future onRequest(RequestOptions options) async{
    if(!AppConfig.enableCache){
      _memoryCache?.removeAll();
      _diskCache?.removeAll();
    }
    if(AppConfig.enableCache
        && options.extra[KEY_NO_CACHE] == true
    ){
      _memoryCache?.removeContain(options.path);
      _diskCache?.removeContain(options.path);
    }
    if(AppConfig.enableCache
        && options.extra[KEY_NO_CACHE] != true
        && options.extra[KEY_NO_STORE] != true
        && options.method.toLowerCase() == 'get'
    ) {
      String key = options.uri.toString();
      ResponseCacheObject cacheObject = _memoryCache?.get(key);
      String responseSource;
      if(cacheObject != null){
        responseSource = RESPONSE_SOURCE_FROM_MEMORY;
      }else{
        cacheObject = await _diskCache?.get(key);
        if(cacheObject != null){
          responseSource = RESPONSE_SOURCE_FROM_DISK;
        }
      }
      if(cacheObject != null){
        //判断是否过期
        if(DateTime.now().millisecondsSinceEpoch - cacheObject.timeStamp < MAX_CACHE_DATE){
          LogUtil.printString(tag, 'onRequest: hit cache, url = ${options.uri}');
          return _buildResponse(cacheObject, options, responseSource);
        }else{
          LogUtil.printString(tag, 'onRequest: cache expired, url = ${options.uri}');
          _memoryCache?.remove(key);
          _diskCache?.remove(key);
        }
      }
    }
    return options;
  }

  @override
  Future onResponse(Response response) async{
    RequestOptions options = response.request;
    if(AppConfig.enableCache
        && options.extra[KEY_NO_STORE] != true
        && options.method.toLowerCase() == 'get'
        && options.responseType != ResponseType.stream
    ){
      String responseSource = response.headers.value(KEY_RESPONSE_SOURCE);
      if(responseSource != RESPONSE_SOURCE_FROM_MEMORY){
        String key = options.uri.toString();
        int statusCode = response.statusCode;
        String headers = jsonEncode(response.headers.map);
        List<int> body = options.responseType == ResponseType.bytes ? response.data : utf8.encode(jsonEncode(response.data));
        ResponseCacheObject cacheObject = ResponseCacheObject(key, statusCode, headers, body);
        _memoryCache?.put(cacheObject);
        if(responseSource == null){
          _diskCache?.put(cacheObject);
        }
        LogUtil.printString(tag, 'onResponse: save cache');
      }
    }
    return response;
  }

  Response _buildResponse(ResponseCacheObject cacheObject, RequestOptions options, String source){
    Headers headers = Headers.fromMap(
        Map<String, List>.from(jsonDecode(cacheObject.headers))
            .map((key, value) => MapEntry(key, List<String>.from(value)))
    );
    headers.set(KEY_RESPONSE_SOURCE, source);
    dynamic data = cacheObject.body;
    if(options.responseType != ResponseType.bytes){
      data = jsonDecode(utf8.decode(data));
    }
    return Response(
      statusCode: cacheObject.statusCode,
      headers: headers,
      data: data,
    );
  }
}