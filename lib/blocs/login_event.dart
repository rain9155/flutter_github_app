part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginButtonPressedEvent extends LoginEvent {}

class LoginSuccessEvent extends LoginEvent{

  const LoginSuccessEvent(this.token);

  final String token;

}

class LoginFailureEvent extends LoginEvent{

  const LoginFailureEvent(this.error);

  final String error;

}

