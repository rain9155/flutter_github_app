import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/user.dart';
import 'package:flutter_github_app/blocs/base.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {

  HomeBloc(this.context) : super(HomeInitialState());

  final BuildContext context;
  User _user;
  int _receivedEventPage = 1;
  List<Event> _receivedEvents = [];
  bool _isRefreshReceivedEvents = false;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is GetReceivedEventsEvent){
      yield GettingReceivedEventsState();
      await refreshReceivedEvents();
    }

    if(event is RefreshedReceivedEventsEvent){
      if(event.error == null){
        yield GetReceivedEventsSuccessState(_receivedEvents, _receivedEvents.length);
      }else{
        yield GetReceivedEventsFailureState(false, _receivedEvents, event.error);
      }
    }

    if(event is GetMoreReceivedEventsEvent){
      try{
        _receivedEventPage++;
        List<Event> receivedEvents = await Api.getInstance().getReceivedEvents(
            _user.login,
            perPage: PER_PAGE,
            page: _receivedEventPage,
            cancelToken: cancelToken
        );
        _receivedEvents.addAll(receivedEvents);
        yield GetReceivedEventsSuccessState(_receivedEvents, receivedEvents.length);
      }catch(e){
        _receivedEventPage--;
        yield GetReceivedEventsFailureState(true, _receivedEvents, AppLocalizations.of(context).loadFail);
      }
    }
  }

  Future<void> refreshReceivedEvents() async {
    if(_isRefreshReceivedEvents){
      return;
    }
    _isRefreshReceivedEvents = true;
    try{
      if(_user == null){
        _user = await Api.getInstance().getUser(cancelToken: cancelToken);
      }
      _receivedEventPage = 1;
      _receivedEvents = await Api.getInstance().getReceivedEvents(
          _user.login,
          perPage: PER_PAGE,
          page: _receivedEventPage,
          cancelToken: cancelToken
      );
      add(RefreshedReceivedEventsEvent(null));
    }on ApiException catch(e){
      add(RefreshedReceivedEventsEvent(CommonUtil.getErrorMsgByCode(context, e.code)));
    }
    _isRefreshReceivedEvents = false;
  }

}
