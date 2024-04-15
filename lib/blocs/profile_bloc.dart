import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/profile.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/cubits/follow_cubit.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';
import '../mixin/bloc_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events/profile_event.dart';
part 'states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with BlocMixin{

  ProfileBloc(this.userCubit) : super(ProfileInitialState()) {
    on<ProfileEvent>(mapEventToState, transformer: sequential());
  }

  final UserCubit userCubit;
  FollowCubit followCubit = FollowCubit();
  Profile? _profile;
  List<Event>? _events;
  int _eventsPage = 1;
  int? _eventsLastPage;
  bool _isRefreshing = false;
  String? _name;
  bool? _isFollowing;
  int? _pageType;

  FutureOr<void> mapEventToState(ProfileEvent event, Emitter<ProfileState> emit) async {
    if(event is GetProfileEvent){
      emit(GettingProfileState());
      _name = event.name;
      _pageType = event.pageType;
      await refreshProfile(isRefresh: false);
    }

    if(event is GotProfileEvent){
      bool _hasMore = hasMore(_eventsLastPage, _eventsPage);
      if(event.errorCode == null){
        emit(GetProfileSuccessState(_profile, _isFollowing, _events, _hasMore));
      }else{
        emit(GetProfileFailureState(_profile, _isFollowing, _events, _hasMore, event.errorCode));
      }
    }

    if(event is FollowUserEvent){
      followCubit.emit(FollowingUserState());
      bool success;
      if(event.isFollow){
        success = await Api.getInstance().followUser(
          _name,
          cancelToken: cancelToken
        );
        _isFollowing = success;
      }else {
        success = await Api.getInstance().unFollowUser(
          _name,
          cancelToken: cancelToken
        );
        _isFollowing = !success;
      }
      followCubit.emit(FollowUserResultState(_isFollowing));
    }
  }

  Future<void> refreshProfile({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      Future getProfile() async{
        _profile = await _getProfileByType(isRefresh: isRefresh);
      }
      Future checkFollowUser() async{
        _isFollowing = await Api.getInstance().checkUserFollowUser(
          _name,
          noCache: isRefresh,
          cancelToken: cancelToken
        );
      }
      Future getEvents() async{
        _eventsPage = 1;
        _events = await _getEvents(_eventsPage, isRefresh: isRefresh);
        _eventsLastPage = Api.getInstance().getUrlLastPage(Url.userEvents(userCubit.name));
      }
      if(_pageType == ROUTE_TYPE_PROFILE_ORG){
        await getProfile();
        _events = [];
      }else if(!CommonUtil.isTextEmpty(_name)){
        if(_name == userCubit.name){
          await getProfile();
        }else{
          await Future.wait([getProfile(), checkFollowUser()], eagerError: true);
        }
        _events = [];
      }else{
        if(CommonUtil.isTextEmpty(userCubit.name)){
          await getProfile();
          await getEvents();
        }else{
          await Future.wait([getProfile(), getEvents()], eagerError: true);
        }
      }
      add(GotProfileEvent());
    }, onError: (code, msg){
      cancelToken.cancel();
      cancelToken = CancelToken();
      add(GotProfileEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreEvents() async{
    return await runBlockCaught(() async{
      _eventsPage++;
      _events!.addAll(await _getEvents(_eventsPage));
      add(GotProfileEvent());
    }, onError: (code, msg){
      _eventsPage--;
      return code;
    });
  }

  Future<Profile> _getProfileByType({bool isRefresh = false}) async{
    Profile profile;
    if(_pageType == PAGE_TYPE_PROFILE_ORG){
      profile = await Api.getInstance().getOrganization(
          _name,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else if(!CommonUtil.isTextEmpty(_name)){
      profile = await Api.getInstance().getUser(
          _name,
          noCache: isRefresh,
          cancelToken: cancelToken
      );
    }else{
      profile = await Api.getInstance().getUser(
          '',
          noCache: isRefresh,
          cancelToken: cancelToken
      );
      userCubit.setName(profile.login);
    }
    return profile;
  }

  Future<List<Event>> _getEvents(int page, {bool isRefresh = false}) async{
    return Api.getInstance().getUserEvents(
        userCubit.name,
        page: page,
        noCache: isRefresh,
        cancelToken: cancelToken
    );
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.userEvents(userCubit.name));
    return super.close();
  }
}
