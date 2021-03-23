part of '../authentication_bloc.dart';

abstract class AuthenticationEvent{
  const AuthenticationEvent();
}

class AppStartedEvent extends AuthenticationEvent {}

class LoggedInEvent extends AuthenticationEvent {

  LoggedInEvent(this.token);

  final String token;
}

class LoggedOutEvent extends AuthenticationEvent {}
