part of '../login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginButtonPressedEvent extends LoginEvent {}

