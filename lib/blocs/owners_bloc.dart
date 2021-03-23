import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_github_app/beans/owner.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:meta/meta.dart';

part 'events/owners_event.dart';
part 'states/owners_state.dart';

class OwnersBloc extends Bloc<OwnersEvent, OwnersState> with BlocMixin{

  OwnersBloc() : super(OwnersInitialState());

  List<Owner> _followers;
  bool _isRefreshing = false;
  int _ownersPage = 1;
  int _ownersLastPage;
  String _name;
  String _repoName;
  int _type;

  @override
  Stream<OwnersState> mapEventToState(OwnersEvent event) async* {
    if(event is GetOwnersEvent){
      yield GettingOwnersState();
      _name = event.name;
      _repoName = event.repoName;
      _type = event.routeType;
      await refreshOwners(event.routeType, isRefresh: false);
    }

    if(event is GotOwnersEvent){
      bool _hasMore = hasMore(_ownersLastPage, _ownersPage);
      if(event.errorCode == null){
        yield GetOwnersSuccessState(_followers, _hasMore);
      }else{
        yield GetOwnersFailureState(_followers, _hasMore, event.errorCode);
      }
    }
  }

  Future<void> refreshOwners(int type, {bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _ownersPage = 1;
      _followers = await _getOwners(_ownersPage, type, isRefresh: isRefresh);
      _ownersLastPage = Api.getInstance().getUrlLastPage(_getOwnersUrlByType(type));
      add(GotOwnersEvent());
    }, onError: (code, msg){
      add(GotOwnersEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int> getMoreOwners(int type) async{
    return await runBlockCaught(() async{
      _ownersPage++;
      _followers.addAll(await _getOwners(_ownersPage, type));
      add(GotOwnersEvent());
    }, onError: (code, msg){
      _ownersPage--;
      return code;
    });
  }

  String _getOwnersUrlByType(int type){
    String url;
    if(type == ROUTE_TYPE_OWNERS_FOLLOWER){
      url = Url.followersUrl(_name);
    }else if(type == ROUTE_TYPE_OWNERS_FOLLOWING){
      url = Url.followingUrl(_name);
    }else if(type == ROUTE_TYPE_OWNERS_MEMBER){
      url = Url.orgMembersUrl(_name);
    }else if(type == ROUTE_TYPE_OWNERS_STARGAZER){
      url = Url.stargazersUrl(_name, _repoName);
    }else if(type == ROUTE_TYPE_OWNERS_WATCHER){
      url = Url.watchersUrl(_name, _repoName);
    }else{
      url = Url.organizationsUrl(_name);
    }
    return url;
  }

  Future<List<Owner>> _getOwners(int page, int type, {bool isRefresh = false}) async{
    List<Owner> owners;
    if(type == ROUTE_TYPE_OWNERS_FOLLOWER){
      owners = await Api.getInstance().getFollowers(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(type == ROUTE_TYPE_OWNERS_FOLLOWING){
      owners = await Api.getInstance().getFollowing(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(type == ROUTE_TYPE_OWNERS_MEMBER){
      owners = await Api.getInstance().getOrgMembers(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(type == ROUTE_TYPE_OWNERS_STARGAZER){
      owners = await Api.getInstance().getStargazers(
          name: _name,
          repoName: _repoName,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(type == ROUTE_TYPE_OWNERS_WATCHER){
      owners = await Api.getInstance().getWatchers(
          name: _name,
          repoName: _repoName,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else{
      owners = await Api.getInstance().getOrganizations(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }
    return owners;
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(_getOwnersUrlByType(_type));
    return super.close();
  }
}
