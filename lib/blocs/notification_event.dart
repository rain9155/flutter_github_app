part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}


class GetNotificationsEvent extends NotificationEvent {}

class RefreshedNotificationsEvent extends NotificationEvent {

  const RefreshedNotificationsEvent(this.error);

  final String error;
}

class UnreadSwitchChangeEvent extends NotificationEvent {

  const UnreadSwitchChangeEvent(this.unread);

  final bool unread;
}