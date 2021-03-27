import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/beans/access_token.dart';
import 'package:flutter_github_app/beans/branch.dart';
import 'package:flutter_github_app/beans/commit.dart';
import 'package:flutter_github_app/beans/content.dart';
import 'package:flutter_github_app/beans/device_code.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/beans/license.dart';
import 'package:flutter_github_app/beans/notification.dart' as Bean;
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/beans/profile.dart';
import 'package:flutter_github_app/beans/pull.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/search.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/env.dart';
import 'package:flutter_github_app/net/http.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';

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

/// Api请求实现类，对应get请求可以通过noCache和noStore实现本地缓存
/// noCache：本次请求不使用缓存，请求服务器，但返回的响应缓存
/// noStore：本次请求不使用缓存，请求服务器，返回的响应也不缓存
class Api{

  static final tag = 'Api';

  static Api _instance;

  static Api getInstance(){
    if(_instance == null){
      _instance = Api._internal();
    }
    return _instance;
  }

  Map<String, dynamic> _headers;
  Map<String, String> _urlLastPages;
  
  Api._internal(){
    _headers = {
      HttpHeaders.userAgentHeader : 'flutter_github_app',
      HttpHeaders.acceptHeader : 'application/vnd.github.v3+json',
    };
    _urlLastPages = {};
  }

  /// 获取deviceCode、userCode和verifyUrl
  Future<DeviceCode> getDeviceCode({
    CancelToken cancelToken
  }) async{
    String url = Url.deviceCodeUrl();
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
      return DeviceCode.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取accessToken
  Future<AccessToken> getAccessToken(String deviceCode, {
    CancelToken cancelToken
  }) async{
    String url = Url.accessTokenUrl();
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
    String url = Url.userUrl('');
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        extras: {
          KEY_NO_STORE: true
        },
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

  /// 获取已授权用户信息
  Future<Profile> getUser(String userName, {
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().get(
        Url.userUrl(userName),
      headers: _headers,
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return Profile.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取组织信息
  Future<Profile> getOrganization(String name, {
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().get(
        Url.organizationUrl(name),
        headers: _headers,
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return Profile.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户因 watching repos 和 following users 而接收到的事件，不同EventType的payload不同，参考：
  /// https://docs.github.com/en/developers/webhooks-and-events/github-event-types
  Future<List<Event>> getReceivedEvents(String userName, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.receivedEventsUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Event> receivedEvents = [];
      datas.forEach((element) {
        receivedEvents.add(Event.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return receivedEvents;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户触发的事件
  Future<List<Event>> getUserEvents(String userName, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.userEvents(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Event> events = [];
      datas.forEach((element) {
        events.add(Event.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return events;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取授权用户接收的通知
  Future<List<Bean.Notification>> getNotifications({
    bool all = true,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.notificationsUrl();
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(all != null) 'all': all,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Bean.Notification> notifications = [];
      datas.forEach((element) {
        notifications.add(Bean.Notification.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return notifications;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取授权用户的问题
  Future<List<Issue>> getIssues({
    String filter = 'all',
    String state = 'all',
    String sort = 'created',
    String direction = 'desc',
    bool pulls = false,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.issuesUrl();
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(!CommonUtil.isTextEmpty(filter)) 'filter': filter,
          if(!CommonUtil.isTextEmpty(state)) 'state': state,
          if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
          if(!CommonUtil.isTextEmpty(direction)) 'direction': direction,
          if(pulls != null) 'pulls': pulls,
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Issue> issues = [];
      datas.forEach((element) {
        issues.add(Issue.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return issues;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户的仓库列表
  Future<List<Repository>> getRepositories(String userName, {
    String type = 'owner',
    String sort = 'pushed',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.repositoriesUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(!CommonUtil.isTextEmpty(type)) 'type': type,
        if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Repository> repositories = [];
      datas.forEach((element) {
        repositories.add(Repository.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return repositories;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户收藏的仓库列表
  Future<List<Repository>> getStarredRepositories(String userName, {
    String sort = 'created',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.starredRepositoriesUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Repository> starred = [];
      datas.forEach((element) {
        starred.add(Repository.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return starred;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户关注的仓库列表
  Future<List<Repository>> getWatchingRepositories(String userName, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.watchingRepositoriesUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Repository> watching = [];
      datas.forEach((element) {
        watching.add(Repository.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return watching;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取组织的仓库
  Future<List<Repository>> getOrgRepositories(String name, {
    String type = 'all',
    String sort = 'pushed',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.orgRepositoriesUrl(name);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(!CommonUtil.isTextEmpty(type)) 'type': type,
        if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Repository> orgRepos = [];
      datas.forEach((element) {
        orgRepos.add(Repository.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return orgRepos;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取仓库的forked仓库
  Future<List<Repository>> getForks({
    String name,
    String repoName,
    String sort = 'oldest',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.forksUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Repository> forks = [];
      datas.forEach((element) {
        forks.add(Repository.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return forks;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户的关注者
  Future<List<Owner>> getFollowers(String userName, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.followersUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> followers = [];
      datas.forEach((element) {
        followers.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return followers;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户的关注
  Future<List<Owner>> getFollowing(String userName, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.followingUrl(userName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> following = [];
      datas.forEach((element) {
        following.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return following;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取用户的组织
  Future<List<Owner>> getOrganizations(String name, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.organizationsUrl(name);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> orgs = [];
      datas.forEach((element) {
        orgs.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return orgs;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取组织的成员
  Future<List<Owner>> getOrgMembers(String name, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.orgMembersUrl(name);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> members = [];
      datas.forEach((element) {
        members.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return members;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取仓库的收藏者
  Future<List<Owner>> getStargazers({
    String name,
    String repoName,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.stargazersUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> stargazers = [];
      datas.forEach((element) {
        stargazers.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return stargazers;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取仓库的关注者
  Future<List<Owner>> getWatchers({
    String name,
    String repoName,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.watchersUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Owner> watchers = [];
      datas.forEach((element) {
        watchers.add(Owner.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return watchers;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取仓库信息
  Future<Repository> getRepository({
    String url,
    String name,
    String repoName,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().get(
      url?? Url.repositoryUrl(name, repoName),
      headers: _headers,
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return Repository.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取仓库的README文件
  Future<String> getReadme({
    @required String name,
    @required String repoName,
    String ref,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    Map<String, dynamic> headers = {...?_headers};
    headers[HttpHeaders.acceptHeader] = 'application/vnd.github.v3.raw';
    HttpResult result = await HttpClient.getInstance().get(
      Url.readmeUrl(name, repoName),
      headers: headers,
      params: {
        if(!CommonUtil.isTextEmpty(ref)) 'ref': ref
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return result.data;
    }else if(result.code == HttpStatus.notFound){
      return '';
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 检查授权用户是否收藏了这个仓库
  Future<bool> checkUserStarRepo({
    @required String name,
    @required String repoName,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().get(
      Url.checkUserStarRepoUrl(name, repoName),
      headers: _headers,
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return true;
    }else if(result.code == HttpStatus.notFound){
      return false;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 授权用户收藏这个仓库
  Future<bool> starRepo({
    @required String name,
    @required String repoName,
    CancelToken cancelToken
  }) async{
    Map<String, dynamic> headers = {...?_headers};
    headers[HttpHeaders.contentLengthHeader] = '0';
    HttpResult result = await HttpClient.getInstance().put(
        Url.checkUserStarRepoUrl(name, repoName),
        headers: headers,
        cancelToken: cancelToken
    );
    return result.code == CODE_SUCCESS;
  }

  /// 授权用户取消收藏这个仓库
  Future<bool> unStarRepo({
    @required String name,
    @required String repoName,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().delete(
        Url.checkUserStarRepoUrl(name, repoName),
        headers: _headers,
        cancelToken: cancelToken
    );
    return result.code == CODE_SUCCESS;
  }

  /// 检查授权用户是否关注了这个用户
  Future<bool> checkUserFollowUser(String userName, {
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().get(
      Url.checkUserFollowUserUrl(userName),
      headers: _headers,
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return true;
    }else if(result.code == HttpStatus.notFound){
      return false;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 授权用户关注这个用户
  Future<bool> followUser(String userName, {
    CancelToken cancelToken
  }) async{
    Map<String, dynamic> headers = {...?_headers};
    headers[HttpHeaders.contentLengthHeader] = '0';
    HttpResult result = await HttpClient.getInstance().put(
        Url.checkUserFollowUserUrl(userName),
        headers: headers,
        cancelToken: cancelToken
    );
    return result.code == CODE_SUCCESS;
  }

  /// 授权用户取消关注这个用户
  Future<bool> unFollowUser(String userName, {
    CancelToken cancelToken
  }) async{
    HttpResult result = await HttpClient.getInstance().delete(
        Url.checkUserFollowUserUrl(userName),
        headers: _headers,
        cancelToken: cancelToken
    );
    return result.code == CODE_SUCCESS;
  }

  ///获取仓库的分支信息
  Future<List<Branch>> getBranches({
    @required String name,
    @required String repoName,
    String protected,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.branchesUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        if(!CommonUtil.isTextEmpty(protected)) 'protected': protected,
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Branch> branches = [];
      datas.forEach((element) {
        branches.add(Branch.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return branches;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取仓库的提交信息
  Future<List<Commit>> getCommits({
    @required String name,
    @required String repoName,
    String ref = 'master',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.commitsUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(!CommonUtil.isTextEmpty(ref)) 'sha': ref,
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Commit> commits = [];
      datas.forEach((element) {
        commits.add(Commit.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return commits;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取仓库的文件列表
  Future<List<Content>> getContents({
    @required String name,
    @required String repoName,
    String path,
    String ref = 'master',
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.contentsUrl(name, repoName, path);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(!CommonUtil.isTextEmpty(ref)) 'ref': ref,
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Content> contents = [];
      datas.forEach((element) {
        contents.add(Content.fromJson(element));
      });
      return contents;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取仓库的代码文件
  Future<String> getContent({
    @required String name,
    @required String repoName,
    @required String path,
    String ref = 'master',
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.contentsUrl(name, repoName, path);
    Map<String, dynamic> headers = {...?_headers};
    headers[HttpHeaders.acceptHeader] = 'application/vnd.github.v3.html';
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: headers,
      params: {
        if(!CommonUtil.isTextEmpty(ref)) 'ref': ref,
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return result.data;
    }else if(result.code == HttpStatus.notFound){
      return '';
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取license文件
  Future<License> getLicense(String key, {
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.licenseUrl(key);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      return License.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取仓库的问题
  Future<List<Issue>> getRepoIssues({
    @required String name,
    @required String repoName,
    String state = 'all',
    String sort = 'created',
    String direction = 'desc',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.repoIssuesUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(!CommonUtil.isTextEmpty(state)) 'state': state,
          if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
          if(!CommonUtil.isTextEmpty(direction)) 'direction': direction,
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Issue> issues = [];
      datas.forEach((element) {
        issues.add(Issue.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return issues;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///获取仓库的拉去请求
  Future<List<Pull>> getRepoPulls({
    @required String name,
    @required String repoName,
    String state = 'all',
    String sort = 'created',
    String direction = 'desc',
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.repoPullsUrl(name, repoName);
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          if(!CommonUtil.isTextEmpty(state)) 'state': state,
          if(!CommonUtil.isTextEmpty(sort)) 'sort': sort,
          if(!CommonUtil.isTextEmpty(direction)) 'direction': direction,
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      List datas = result.data;
      List<Pull> pulls = [];
      datas.forEach((element) {
        pulls.add(Pull.fromJson(element));
      });
      _parseLastPage(result.headers, url);
      return pulls;
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///根据关键字搜索问题或拉取请求
  Future<Search> getSearchIssues(String key, {
    bool onlyIssue = false,
    bool onlyPull = false,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.searchIssuesUrl();
    HttpResult result = await HttpClient.getInstance().get(
      url,
      headers: _headers,
      params: {
        'q': onlyIssue ? '$key type:issues' : onlyPull ? '$key type:pr' : '$key',
        if(perPage > 0) 'per_page': perPage,
        if(page > 0) 'page': page
      },
      extras: {
        KEY_NO_CACHE: noCache,
        KEY_NO_STORE: noStore
      },
      cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      _parseLastPage(result.headers, url);
      return Search.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///根据关键字搜索用户或组织
  Future<Search> getSearchUsers(String key, {
    bool onlyUser = false,
    bool onlyOrg = false,
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.searchUsersUrl();
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          'q': onlyUser ? '$key type:user' : onlyOrg ? '$key type:org' : '$key',
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      _parseLastPage(result.headers, url);
      return Search.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  ///根据关键字搜索仓库
  Future<Search> getSearchRepos(String key, {
    int perPage = -1,
    int page = -1,
    bool noCache,
    bool noStore,
    CancelToken cancelToken
  }) async{
    String url = Url.searchReposUrl();
    HttpResult result = await HttpClient.getInstance().get(
        url,
        headers: _headers,
        params: {
          'q': '$key',
          if(perPage > 0) 'per_page': perPage,
          if(page > 0) 'page': page
        },
        extras: {
          KEY_NO_CACHE: noCache,
          KEY_NO_STORE: noStore
        },
        cancelToken: cancelToken
    );
    if(result.code == CODE_SUCCESS){
      _parseLastPage(result.headers, url);
      return Search.fromJson(result.data);
    }else{
      throw ApiException(code: result.code, msg: result.msg);
    }
  }

  /// 获取对应url的lastPage
  int getUrlLastPage(String url, {String query}){
    Iterable<String> keys = _urlLastPages.keys;
    String key;
    if(CommonUtil.isTextEmpty(query)){
      key = keys.firstWhere((element) => element.contains(url), orElse: () => url);
    }else{
      key = keys.firstWhere((element) => element.contains(url) && element.contains(query), orElse: () => url);
    }
    return int.tryParse(_urlLastPages[key]?? '');
  }

  /// 移除对应url的lastPage
  void removeUrlLastPage(String url, {String query}){
    if(CommonUtil.isTextEmpty(query)){
      _urlLastPages.removeWhere((key, value) => key.contains(url));
    }else{
      _urlLastPages.removeWhere((key, value) => key.contains(url) && key.contains(query));
    }
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

  /// github支持pagination，可以通过response headers获取分页的信息，参考：
  /// https://docs.github.com/en/rest/guides/traversing-with-pagination
  _parseLastPage(Headers responseHeaders, String url){
    if(responseHeaders['link'] != null){
      String linkHeaderValue = responseHeaders['link'][0];
      List<String> splits = linkHeaderValue.split(',');
      String lastPageLink;
      for(int i = 0; i < splits.length; i++){
        String element = splits[i];
        if(element.contains('last')){
          lastPageLink = element.substring(element.indexOf('<') + 1, element.lastIndexOf('>'));
          break;
        }
      }
      Uri lastPageUri = Uri.tryParse(lastPageLink?? '');
      String lastPage = lastPageUri?.queryParameters['page'];
      if(!CommonUtil.isTextEmpty(lastPage)){
        Map<String, dynamic> queries = Map.from(lastPageUri.queryParameters);
        queries?.remove('page');
        Uri uri = Uri.tryParse(url);
        String uriPageRemoved = Uri(
          scheme: uri?.scheme,
          host: uri?.host,
          port: uri?.port,
          path: uri?.path,
          queryParameters: queries != null && queries.isNotEmpty ? queries : null,
        ).toString();
        if(_urlLastPages[uriPageRemoved] == null){
          _urlLastPages[uriPageRemoved] = lastPage;
        }
        LogUtil.printString(tag, '_parseLastPage: uriPageRemoved = $uriPageRemoved');
      }
      LogUtil.printString(tag, '_parseLastPage: lastPageLink = $lastPageLink');
    }
  }

}