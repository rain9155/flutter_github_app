import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/beans/search.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/searches_event.dart';
part 'states/searches_state.dart';

class SearchesBloc extends Bloc<SearchesEvent, SearchesState> with BlocMixin{

  SearchesBloc() : super(SearchesInitialState());

  String? _key;
  int? _routeType;
  bool _isRefreshing = false;
  List<Issue>? _issues;
  List<Owner>? _users;
  List<Repository>? _repos;
  int _page = 1;
  int? _lastPage;

  @override
  Stream<SearchesState> mapEventToState(SearchesEvent event) async* {
    if(event is GetSearchesEvent){
      yield GettingSearchesState();
      _key = event.key;
      _routeType = event.routeType;
      await refreshSearches(isRefresh: false);
    }

    if(event is GotSearchesEvent){
      bool _hasMore = hasMore(_lastPage, _page);
      if(event.errorCode == null){
        yield GetSearchesSuccessState(issues: _issues, users: _users, repos: _repos, hasMore: _hasMore);
      }else{
        yield GetSearchesFailureState(event.errorCode, issues: _issues, users: _users, repos: _repos, hasMore: _hasMore);
      }
    }
  }

  Future<void> refreshSearches({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _page = 1;
      Search search = await _getSearchesByType(_page, isRefresh: isRefresh);
      _lastPage = Api.getInstance().getUrlLastPage(_getSearchUrlByType());
      if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE || _routeType == ROUTE_TYPE_SEARCHES_PULL){
        _issues = [];
        search.items!.forEach((element) {
          _issues!.add(Issue.fromJson(element));
        });
      }else if(_routeType == ROUTE_TYPE_SEARCHES_USER || _routeType == ROUTE_TYPE_SEARCHES_ORG){
        _users = [];
        search.items!.forEach((element) {
          _users!.add(Owner.fromJson(element));
        });
      }else{
        _repos = [];
        search.items!.forEach((element) {
          _repos!.add(Repository.fromJson(element));
        });
      }
      add(GotSearchesEvent());
    }, onError: (code, msg){
      add(GotSearchesEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreSearches() async{
    return await runBlockCaught(() async{
      _page++;
      Search search = await _getSearchesByType(_page);
      if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE || _routeType == ROUTE_TYPE_SEARCHES_PULL){
        List<Issue> issue = [];
        search.items!.forEach((element) {
          issue.add(Issue.fromJson(element));
        });
        _issues!.addAll(issue);
      }else if(_routeType == ROUTE_TYPE_SEARCHES_USER || _routeType == ROUTE_TYPE_SEARCHES_ORG){
        List<Owner> users = [];
        search.items!.forEach((element) {
          users.add(Owner.fromJson(element));
        });
        _users!.addAll(users);
      }else{
        List<Repository> repos = [];
        search.items!.forEach((element) {
          repos.add(Repository.fromJson(element));
        });
        _repos!.addAll(repos);
      }
      add(GotSearchesEvent());
    }, onError: (code, msg){
      _page--;
      return code;
    });
  }

  String _getSearchUrlByType(){
    String url;
    if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE || _routeType == ROUTE_TYPE_SEARCHES_PULL){
      url = Url.searchIssuesUrl();
    }else if(_routeType == ROUTE_TYPE_SEARCHES_USER || _routeType == ROUTE_TYPE_SEARCHES_ORG){
      url = Url.searchUsersUrl();
    }else{
      url = Url.searchReposUrl();
    }
    return url;
  }

  Future<Search> _getSearchesByType(int page, {bool isRefresh = false}) async{
    Search search;
    if(_routeType == ROUTE_TYPE_SEARCHES_ISSUE){
      search = await Api.getInstance().getSearchIssues(
        _key,
        onlyIssue: true,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }else if(_routeType == ROUTE_TYPE_SEARCHES_PULL){
      search = await Api.getInstance().getSearchIssues(
          _key,
          onlyPull: true,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_routeType == ROUTE_TYPE_SEARCHES_USER){
      search = await Api.getInstance().getSearchUsers(
          _key,
          onlyUser: true,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_routeType == ROUTE_TYPE_SEARCHES_ORG){
      search = await Api.getInstance().getSearchUsers(
          _key,
          onlyOrg: true,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else{
      search = await Api.getInstance().getSearchRepos(
          _key,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }
    return search;
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(_getSearchUrlByType());
    return super.close();
  }
}
