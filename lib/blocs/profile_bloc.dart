import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/user.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';
import 'base.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {

  ProfileBloc(this.context) : super(ProfileInitialState());

  final BuildContext context;
  User _user;
  List<Event> _events;
  int _eventPage = 1;
  bool _isRefreshUser = false;

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if(event is GetUserEvent){
      yield GettingUserState();
      await refreshUser();
    }

    if(event is RefreshedUserEvent){
      if(event.error == null){
        yield GetUserSuccessState(_user, _events, _events.length);
      }else{
        yield GetUserFailureState(false, _user, _events, event.error);
      }
    }

    if(event is GetMoreUserEventsEvent){
      try{
        _eventPage++;
        List<Event> events = await Api.getInstance().getUserEvents(
            _user.login,
            perPage: PER_PAGE,
            page: _eventPage
        );
        _events.addAll(events);
        yield GetUserSuccessState(_user, _events, events.length);
      }on ApiException catch(e){
        _eventPage--;
        yield GetUserFailureState(true, _user, _events, AppLocalizations.of(context).loadFail);
      }
    }
  }

  Future<void> refreshUser() async{
    if(_isRefreshUser){
      return;
    }
    _isRefreshUser = true;
    try{
      _user = await Api.getInstance().getUser(cancelToken: cancelToken);
      _eventPage = 1;
      _events = await Api.getInstance().getUserEvents(
        _user.login,
        perPage: PER_PAGE,
        page: _eventPage
      );
      add(RefreshedUserEvent(null));
    }on ApiException catch(e){
      add(RefreshedUserEvent(CommonUtil.getErrorMsgByCode(context, e.code)));
    }
    _isRefreshUser = false;
  }

}
