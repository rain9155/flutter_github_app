part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {
  const NotificationState();
}

class NotificationInitialState extends NotificationState {}

class GettingNotificationState extends NotificationState {}

class GetNotificationSuccessState extends NotificationState {

  const GetNotificationSuccessState(this.notificatons);

  final List<Bean.Notification> notificatons;

}

class GetNotificationFailureState extends NotificationState {

  const GetNotificationFailureState(this.notificatons, this.error);

  final List<Bean.Notification> notificatons;

  final String error;
}
