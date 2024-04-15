import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
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

class NotificationOwner{

  const NotificationOwner(
    this.repoName,
    this.repoOwnerAvatarUrl
  );

  final String? repoName;

  final String? repoOwnerAvatarUrl;

  @override
  bool operator ==(Object other) => repoName.hashCode == other.hashCode;

  @override
  int get hashCode => repoName.hashCode;
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> with BlocMixin{

  NotificationBloc() : super(NotificationInitialState()) {
    on<NotificationEvent>(mapEventToState, transformer: sequential());
  }

  List<Bean.Notification>? _notifications;
  List<NotificationOwner>? notificationOwners;
  late bool all;
  String? filterName;
  bool _isRefreshing = false;
  int _notificationsPage = 1;
  int? _notificationsLastPage;

  FutureOr<void> mapEventToState(NotificationEvent event, Emitter<NotificationState> emit) async {
    if(event is GetNotificationsEvent){
      emit(GettingNotificationState(filterName));
      all = !(await SharedPreferencesUtil.getBool(KEY_UNREAD));
      await refreshNotifications(isRefresh: false);
    }

    if(event is GotNotificationsEvent){
      bool _hasMore = hasMore(_notificationsLastPage, _notificationsPage);
      List<Bean.Notification>? notificationsFiltered;
      if(_notifications != null){
        notificationsFiltered = [];
        _notifications!.forEach((element) {
          if((element.unread == !all || all)
              && (element.repository!.fullName == filterName || filterName == null)
          ){
            notificationsFiltered!.add(element);
          }
        });
      }
      if(event.errorCode == null){
        emit(GetNotificationSuccessState(notificationsFiltered, _hasMore, filterName));
      }else{
        emit(GetNotificationFailureState(notificationsFiltered, _hasMore, filterName, event.errorCode));
      }
    }

    if(event is UnreadSwitchChangeEvent){
      emit(GettingNotificationState(filterName));
      all = !event.unread;
      SharedPreferencesUtil.setBool(KEY_UNREAD, event.unread);
      add(GotNotificationsEvent());
    }

    if(event is FilterChangeEvent && event.filterName != filterName){
      emit(GettingNotificationState(filterName));
      filterName = event.filterName;
      add(GotNotificationsEvent());
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

  Future<int?> getMoreNotifications() async{
    return await runBlockCaught(() async{
      _notificationsPage++;
      _notifications!.addAll(await _getNotifications(_notificationsPage));
      add(GotNotificationsEvent());
    }, onError: (code, msg){
      _notificationsPage--;
      return code;
    });
  }

  Future<List<Bean.Notification>> _getNotifications(int page, {bool isRefresh = false}) async{
    List<Bean.Notification> notifications = await Api.getInstance().getNotifications(
      page: page,
      noCache: isRefresh,
      cancelToken: cancelToken
    );
    notificationOwners = [];
    notifications.forEach((element) {
      if(!notificationOwners!.contains(element.repository!.fullName)){
        notificationOwners!.add(NotificationOwner(
          element.repository!.fullName,
          element.repository!.owner!.avatarUrl
        ));
      }
    });
    return notifications;
  }

  @override
  Future<void> close() {
    Api.getInstance().removeUrlLastPage(Url.notificationsUrl());
    return super.close();
  }
}
