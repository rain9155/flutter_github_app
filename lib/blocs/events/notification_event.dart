part of '../notification_bloc.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

class GetNotificationsEvent extends NotificationEvent {}

class GotNotificationsEvent extends NotificationEvent {

  const GotNotificationsEvent({
    this.errorCode
  });

  final int? errorCode;
}

class UnreadSwitchChangeEvent extends NotificationEvent {

  const UnreadSwitchChangeEvent(this.unread);

  final bool unread;
}

class FilterChangeEvent extends NotificationEvent {

  const FilterChangeEvent(this.filterName);

  final String? filterName;
}