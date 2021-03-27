import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/repository.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/repos_event.dart';
part 'states/repos_state.dart';

class ReposBloc extends Bloc<ReposEvent, ReposState> with BlocMixin{

  ReposBloc() : super(ReposInitialState());

  List<Repository> _repositories;
  bool _isRefreshing = false;
  int _reposPage = 1;
  int _reposLastPage;
  String _name;
  String _repoName;
  int _type;

  @override
  Stream<ReposState> mapEventToState(ReposEvent event) async* {
    if(event is GetReposEvent){
      yield GettingReposState();
      _name = event.name;
      _repoName = event.repoName;
      _type = event.routeType;
      await refreshRepos(isRefresh: false);
    }

    if(event is GotReposEvent){
      bool _hasMore = hasMore(_reposLastPage, _reposPage);
      if(event.errorCode == null){
        yield GetReposSuccessState(_repositories, _hasMore);
      }else{
        yield GetReposFailureState(_repositories, _hasMore, event.errorCode);
      }
    }
  }

  Future<void> refreshRepos({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _reposPage = 1;
      _repositories = await _getRepositoriesByType(_reposPage, isRefresh: isRefresh);
      _reposLastPage = Api.getInstance().getUrlLastPage(_getReposUrlByType());
      add(GotReposEvent());
    }, onError: (code, msg){
      add(GotReposEvent(errorCode:  code));
    });
    _isRefreshing = false;
  }

  Future<int> getMoreRepos() async{
    return await runBlockCaught(() async{
      _reposPage++;
      _repositories.addAll(await _getRepositoriesByType(_reposPage));
      add(GotReposEvent());
    }, onError: (code, msg){
      _reposPage--;
      return code;
    });
  }

  String _getReposUrlByType() {
    String url;
    if(_type == ROUTE_TYPE_REPOS_WATCHING){
      url = Url.watchingRepositoriesUrl(_name);
    }else if(_type == ROUTE_TYPE_REPOS_STARRED){
      url = Url.starredRepositoriesUrl(_name);
    }else if(_type == ROUTE_TYPE_REPOS_ORG){
      url = Url.orgRepositoriesUrl(_name);
    }else if(_type == ROUTE_TYPE_REPOS_FORK){
      url = Url.forksUrl(_name, _repoName);
    }else{
      url = Url.repositoriesUrl(_name);
    }
    return url;
  }

  Future<List<Repository>> _getRepositoriesByType(int page, {bool isRefresh = false}) async{
    List<Repository> repositories;
    if(_type == ROUTE_TYPE_REPOS_WATCHING){
      repositories = await Api.getInstance().getWatchingRepositories(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_REPOS_STARRED){
      repositories = await Api.getInstance().getStarredRepositories(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_REPOS_ORG){
      repositories = await Api.getInstance().getOrgRepositories(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_REPOS_FORK){
      repositories = await Api.getInstance().getForks(
        name: _name,
        repoName: _repoName,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }else{
      repositories = await Api.getInstance().getRepositories(
        _name,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
      );
    }
    return repositories;
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(_getReposUrlByType());
    return super.close();
  }
}
