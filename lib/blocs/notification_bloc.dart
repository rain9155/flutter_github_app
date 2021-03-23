import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/beans/notification.dart' as Bean;
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/configs/method.dart';
import 'package:flutter_github_app/mixin/bloc_mixin.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/net/url.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

part 'events/notification_event.dart';
part 'states/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> with BlocMixin{

  NotificationBloc() : super(NotificationInitialState());

  List<Bean.Notification> _notifications;
  bool _isRefreshing = false;
  int _notificationsPage = 1;
  int _notificationsLastPage;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if(event is GetNotificationsEvent){
      yield GettingNotificationState();
      await refreshNotifications(isRefresh: false);
    }

    if(event is GotNotificationsEvent){
      bool _hasMore = hasMore(_notificationsLastPage, _notificationsPage);
      if(event.errorCode == null){
        yield GetNotificationSuccessState(_notifications, _hasMore);
      }else{
        yield GetNotificationFailureState(_notifications, _hasMore, event.errorCode);
      }
    }

    if(event is UnreadSwitchChangeEvent){
      await SharedPreferencesUtil.setBool(KEY_UNREAD, event.unread);
    }
  }

  Future<void> refreshNotifications({bool isRefresh = true}) async{
    if(_isRefreshing){
      return;
    }
    _isRefreshing = true;
    await runBlockCaught(() async{
      _notificationsPage = 1;
      _notifications = await _getNotifications(_notificationsPage, isRefresh: isRefresh);
      _notificationsLastPage = Api.getInstance().getUrlLastPage(Url.notificationsUrl());
      add(GotNotificationsEvent());
    }, onError: (code, msg){
      add(GotNotificationsEvent(errorCode: code));
    });
    _isRefreshing = false;
  }

  Future<int> getMoreNotifications() async{
    return await runBlockCaught(() async{
      _notificationsPage++;
      _notifications.addAll(await _getNotifications(_notificationsPage));
      add(GotNotificationsEvent());
    }, onError: (code, msg){
      _notificationsPage--;
      return code;
    });
  }

  Future<List<Bean.Notification>> _getNotifications(int page, {bool isRefresh = false}) async{
    bool unread = await SharedPreferencesUtil.getBool(KEY_UNREAD);
    return Api.getInstance().getNotifications(
      all: !unread,
      page: page,
      noCache: isRefresh,
      cancelToken: cancelToken
    );
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.notificationsUrl());
    return super.close();
  }
}
