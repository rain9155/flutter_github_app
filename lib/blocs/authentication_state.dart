part of 'authentication_bloc.dart';

abstract class AuthenticationState{
  const AuthenticationState();
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticatedState extends AuthenticationState {}

class UnauthenticatedState extends AuthenticationState {}
