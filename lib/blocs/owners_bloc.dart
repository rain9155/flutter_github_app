import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

  OwnersBloc() : super(OwnersInitialState()) {
    on<OwnersEvent>(mapEventToState, transformer: sequential());
  }

  List<Owner>? _followers;
  bool _isRefreshing = false;
  int _ownersPage = 1;
  int? _ownersLastPage;
  String? _name;
  String? _repoName;
  int? _type;

  FutureOr<void> mapEventToState(OwnersEvent event, Emitter<OwnersState> emit) async {
    if(event is GetOwnersEvent){
      emit(GettingOwnersState());
      _name = event.name;
      _repoName = event.repoName;
      _type = event.routeType;
      await refreshOwners(isRefresh: false);
    }

    if(event is GotOwnersEvent){
      bool _hasMore = hasMore(_ownersLastPage, _ownersPage);
      if(event.errorCode == null){
        emit(GetOwnersSuccessState(_followers, _hasMore));
      }else{
        emit(GetOwnersFailureState(_followers, _hasMore, event.errorCode));
      }
    }
  }

  Future<void> refreshOwners({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _ownersPage = 1;
      _followers = await _getOwnersByType(_ownersPage, isRefresh: isRefresh);
      _ownersLastPage = Api.getInstance().getUrlLastPage(_getOwnersUrlByType());
      add(GotOwnersEvent());
    }, onError: (code, msg){
      add(GotOwnersEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreOwners() async{
    return await runBlockCaught(() async{
      _ownersPage++;
      _followers!.addAll(await _getOwnersByType(_ownersPage));
      add(GotOwnersEvent());
    }, onError: (code, msg){
      _ownersPage--;
      return code;
    });
  }

  String _getOwnersUrlByType(){
    String url;
    if(_type == ROUTE_TYPE_OWNERS_FOLLOWER){
      url = Url.followersUrl(_name);
    }else if(_type == ROUTE_TYPE_OWNERS_FOLLOWING){
      url = Url.followingUrl(_name);
    }else if(_type == ROUTE_TYPE_OWNERS_MEMBER){
      url = Url.orgMembersUrl(_name);
    }else if(_type == ROUTE_TYPE_OWNERS_STARGAZER){
      url = Url.stargazersUrl(_name, _repoName);
    }else if(_type == ROUTE_TYPE_OWNERS_WATCHER){
      url = Url.watchersUrl(_name, _repoName);
    }else{
      url = Url.organizationsUrl(_name);
    }
    return url;
  }

  Future<List<Owner>> _getOwnersByType(int page, {bool isRefresh = false}) async{
    List<Owner> owners;
    if(_type == ROUTE_TYPE_OWNERS_FOLLOWER){
      owners = await Api.getInstance().getFollowers(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_OWNERS_FOLLOWING){
      owners = await Api.getInstance().getFollowing(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_OWNERS_MEMBER){
      owners = await Api.getInstance().getOrgMembers(
          _name,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_OWNERS_STARGAZER){
      owners = await Api.getInstance().getStargazers(
          name: _name,
          repoName: _repoName,
          page: page,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(_type == ROUTE_TYPE_OWNERS_WATCHER){
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
    Api.getInstance().removeUrlLastPage(_getOwnersUrlByType());
    return super.close();
  }
}
