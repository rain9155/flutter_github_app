part of '../notification_bloc.dart';

@immutable
abstract class NotificationState {
  const NotificationState();
}

class NotificationInitialState extends NotificationState {}

class GettingNotificationState extends NotificationState {

  const GettingNotificationState(this.filterName);

  final String? filterName;
}

class GetNotificationSuccessState extends NotificationState {

  const GetNotificationSuccessState(
    this.notifications,
    this.hasMore,
    this.filterName
  );

  final List<Bean.Notification>? notifications;

  final bool hasMore;

  final String? filterName;
}

class GetNotificationFailureState extends GetNotificationSuccessState {

  const GetNotificationFailureState(
    List<Bean.Notification>? notifications,
    bool hasMore,
    String? filterName,
    this.errorCode
  ): super(notifications, hasMore, filterName);

  final int? errorCode;
}
