part of '../notification_bloc.dart';

@immutable
abstract class NotificationState {
  const NotificationState();
}

class NotificationInitialState extends NotificationState {}

class GettingNotificationState extends NotificationState {}

class GetNotificationSuccessState extends NotificationState {

  const GetNotificationSuccessState(this.notifications, this.hasMore);

  final List<Bean.Notification> notifications;

  final bool hasMore;
}

class GetNotificationFailureState extends GetNotificationSuccessState {

  const GetNotificationFailureState(
    List<Bean.Notification> notifications,
    bool hasMore,
    this.errorCode
  ): super(notifications, hasMore);

  final int errorCode;
}
