import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/beans/issue.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/beans/search.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/db/db_helper.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';

part 'events/search_event.dart';
part 'states/search_state.dart';

class HistoriesCache{

  static final tag = 'HistoryStore';

  final String _tableName = 'HistoryCache';
  final String _colId = 'id';
  final String _colHistory = 'history';

  bool _isTableCreated = false;

  Future _createTable() async{
    if(!_isTableCreated){
      await DBHelper.getInstance().execute('''
        CREATE TABLE IF NOT EXISTS $_tableName (
          $_colId integer primary key autoincrement,
          $_colHistory text not null
        )
      ''');
      _isTableCreated = true;
    }
  }

  Future put(String? history) async{
    await _createTable();
    await DBHelper.getInstance().insert(
      _tableName,
      {_colHistory: history},
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<bool> contain(String? history) async{
    await _createTable();
    List<Map<String, Object?>> results = await DBHelper.getInstance().query(
        _tableName,
        where: '$_colHistory = ?',
        whereArgs: [history],
    );
    return results.length > 0;
  }

  Future<List<String?>> getAll() async{
    await _createTable();
    List<Map<String, Object?>> results = await DBHelper.getInstance().query(
      _tableName,
      orderBy: '$_colId desc'
    );
    List<String?> histories = [];
    results.forEach((element) {
      histories.add(element[_colHistory] as String?);
    });
    return histories;
  }

  Future remove(String? history) async{
    await DBHelper.getInstance().delete(
        _tableName,
        where: '$_colHistory = ?',
        whereArgs: [history]
    );
  }

  Future removeAll() async{
    if(_isTableCreated){
      await DBHelper.getInstance().delete(_tableName);
      _isTableCreated = false;
    }
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> with BlocMixin{

  SearchBloc() : super(SearchInitialState()) {
    on<SearchEvent>(mapEventToState, transformer: sequential());
  }

  final HistoriesCache _historiesCache = HistoriesCache();
  List<String?> _history = [];
  bool _hasText = false;
  List<Issue>? _issues;
  List<Issue>? _pulls;
  List<Owner>? _users;
  List<Owner>? _orgs;
  List<Repository>? _repos;
  int? _totalIssuesCount;
  int? _totalPullsCount;
  int? _totalOrgsCount;
  int? _totalUsersCount;
  int? _totalReposCount;

  FutureOr<void> mapEventToState(SearchEvent event, Emitter<SearchState> emit) async {
    if(event is GetHistoriesEvent){
      runBlockCaught(() async{
        _history = await _historiesCache.getAll();
        add(GotHistoriesEvent());
      });
    }

    if(event is GotHistoriesEvent && !_hasText){
      emit(ShowHistoriesState(_history));
    }

    if(event is DeleteHistoryEvent){
      runBlockCaught(() async{
        _historiesCache.remove(event.history);
      });
      _history.remove(event.history);
      if(!_hasText){
        emit(ShowHistoriesState(_history));
      }
    }

    if(event is DeleteHistoriesEvent){
      runBlockCaught(() async{
        _historiesCache.removeAll();
      });
      _history.clear();
      if(!_hasText){
        emit(ShowHistoriesState(_history));
      }
    }

    if(event is SaveHistoryEvent && !CommonUtil.isTextEmpty(event.history)){
      runBlockCaught(() async{
        if(await _historiesCache.contain(event.history)){
          await _historiesCache.remove(event.history);
        }
        _historiesCache.put(event.history);
      });
      if(_history.contains(event.history)){
        _history.remove(event.history);
      }
      _history.insert(0, event.history);
      if(!_hasText){
        emit(ShowHistoriesState(_history));
      }
    }

    if(event is TextChangedEvent){
      _hasText = event.hasText;
      if(_hasText){
        emit(ShowGuidesState());
      }else{
        _cancelSearch();
        emit(ShowHistoriesState(_history));
      }
    }

    if(event is StartSearchEvent && !CommonUtil.isTextEmpty(event.key)){
      emit(SearchingState());
      runBlockCaught(() async{
        _cancelSearch();
        await _search(event.key);
        add(GotSearchEvent());
      }, onError: (code, msg){
        if(code != CODE_REQUEST_CANCEL){
          add(GotSearchEvent(errorCode: code));
        }
      });
    }

    if(event is GotSearchEvent && _hasText){
      if(event.errorCode == null){
        emit(
          SearchSuccessState(
            issues: _issues,
            pulls: _pulls,
            users: _users,
            orgs: _orgs,
            repos: _repos,
            totalIssuesCount: _totalIssuesCount,
            totalPullsCount: _totalPullsCount,
            totalOrgsCount: _totalOrgsCount,
            totalUsersCount: _totalUsersCount,
            totalReposCount: _totalReposCount
          )
        );
      }else{
        emit(SearchFailureState(event.errorCode));
      }
    }
  }

  Future _search(String? key){
    Future searchIssues() async{
      _issues = null;
      Search search = await Api.getInstance().getSearchIssues(
        key,
        onlyIssue: true,
        noStore: true,
        perPage: 3,
        page: 1,
        cancelToken: cancelToken
      );
      _totalIssuesCount = search.totalCount;
      _issues = [];
      search.items!.forEach((element) {
        _issues!.add(Issue.fromJson(element));
      });
    }
    Future searchPulls() async{
      _pulls = null;
      Search search = await Api.getInstance().getSearchIssues(
        key,
        onlyPull: true,
        noStore: true,
        perPage: 3,
        page: 1,
        cancelToken: cancelToken
      );
      _totalPullsCount = search.totalCount;
      _pulls = [];
      search.items!.forEach((element) {
        _pulls!.add(Issue.fromJson(element));
      });
    }
    Future searchUsers() async{
      _users = null;
      Search search = await Api.getInstance().getSearchUsers(
        key,
        onlyUser: true,
        noStore: true,
        perPage: 3,
        page: 1,
        cancelToken: cancelToken
      );
      _totalUsersCount = search.totalCount;
      _users = [];
      search.items!.forEach((element) {
        _users!.add(Owner.fromJson(element));
      });
    }
    Future searchOrgs() async{
      _orgs = null;
      Search search = await Api.getInstance().getSearchUsers(
        key,
        onlyOrg: true,
        noStore: true,
        perPage: 3,
        page: 1,
        cancelToken: cancelToken
      );
      _totalOrgsCount = search.totalCount;
      _orgs = [];
      search.items!.forEach((element) {
        _orgs!.add(Owner.fromJson(element));
      });
    }
    Future searchRepos() async{
      _repos = null;
      Search search = await Api.getInstance().getSearchRepos(
        key,
        noStore: true,
        perPage: 3,
        page: 1,
        cancelToken: cancelToken
      );
      _totalReposCount  = search.totalCount;
      _repos = [];
      search.items!.forEach((element) {
        _repos!.add(Repository.fromJson(element));
      });
    }
    return Future.wait([
      searchIssues(),
      searchPulls(),
      searchUsers(),
      searchOrgs(),
      searchRepos()
    ]);
  }

  _cancelSearch(){
    cancelToken.cancel();
    cancelToken = CancelToken();
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.searchReposUrl());
    Api.getInstance().removeUrlLastPage(Url.searchIssuesUrl());
    Api.getInstance().removeUrlLastPage(Url.searchUsersUrl());
    return super.close();
  }
}
