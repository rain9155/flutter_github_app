import 'dart:async';
import 'package:flutter_github_app/beans/notification.dart' as Bean;
import 'package:flutter/cupertino.dart';
import 'package:flutter_github_app/blocs/base.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends BaseBloc<NotificationEvent, NotificationState> {

  NotificationBloc(this.context) : super(NotificationInitialState());

  final BuildContext context;
  List<Bean.Notification> _notifications = [];
  bool _isRefreshNotifications = false;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if(event is GetNotificationsEvent){
      yield GettingNotificationState();
      await refreshNotifications();
    }

    if(event is RefreshedNotificationsEvent){
      if(event.error == null){
        yield GetNotificationSuccessState(_notifications);
      }else{
        yield GetNotificationFailureState(_notifications, event.error);
      }
    }

    if(event is UnreadSwitchChangeEvent){
      await SharedPreferencesUtil.setBool(KEY_UNREAD, event.unread);
    }
  }

  Future<void> refreshNotifications() async{
    if(_isRefreshNotifications){
      return;
    }
    _isRefreshNotifications = true;
    try{
      bool unread = await SharedPreferencesUtil.getBool(KEY_UNREAD);
      _notifications = await Api.getInstance().getNotifications(
          all: !unread,
          cancelToken: cancelToken
      );
      add(RefreshedNotificationsEvent(null));
    }on ApiException catch(e){
      add(RefreshedNotificationsEvent(CommonUtil.getErrorMsgByCode(context, e.code)));
    }
    _isRefreshNotifications = false;
  }
}
