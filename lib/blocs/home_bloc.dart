import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/event.dart';
import 'package:flutter_github_app/beans/profile.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:meta/meta.dart';

part 'events/home_event.dart';
part 'states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> with BlocMixin{

  HomeBloc(this.userCubit) : super(HomeInitialState());

  final UserCubit userCubit;
  List<Event>? _receivedEvents;
  int _receivedEventsPage = 1;
  int? _receivedEventsLastPage;
  bool _isRefreshing = false;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if(event is GetReceivedEventsEvent){
      yield GettingReceivedEventsState();
      await refreshReceivedEvents(isRefresh: false);
    }

    if(event is GotReceivedEventsEvent){
      bool _hasMore = hasMore(_receivedEventsLastPage, _receivedEventsPage);
      if(event.errorCode == null){
        yield GetReceivedEventsSuccessState(_receivedEvents, _hasMore);
      }else{
        yield GetReceivedEventsFailureState(_receivedEvents, _hasMore, event.errorCode);
      }
    }
  }

  Future<void> refreshReceivedEvents({bool isRefresh = true}) async {
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      if(CommonUtil.isTextEmpty(userCubit.name)){
        Profile user = await Api.getInstance().getUser('', cancelToken: cancelToken);
        userCubit.setName(user.login);
      }
      _receivedEventsPage = 1;
      _receivedEvents = await _getReceivedEvents(_receivedEventsPage, isRefresh: isRefresh);
      _receivedEventsLastPage = Api.getInstance().getUrlLastPage(Url.receivedEventsUrl(userCubit.name));
      add(GotReceivedEventsEvent());
    }, onError: (code, msg){
      add(GotReceivedEventsEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int?> getMoreReceivedEvents() async{
    return await runBlockCaught(() async{
      _receivedEventsPage++;
      _receivedEvents!.addAll(await _getReceivedEvents(_receivedEventsPage));
      add(GotReceivedEventsEvent());
    }, onError: (code, msg){
      _receivedEventsPage--;
      return code;
    });
  }

  Future<List<Event>> _getReceivedEvents(int page, {bool isRefresh = false}){
    return Api.getInstance().getReceivedEvents(
        userCubit.name,
        page: _receivedEventsPage,
        noCache: isRefresh,
        cancelToken: cancelToken
    );
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.receivedEventsUrl(userCubit.name));
    return super.close();
  }
}
