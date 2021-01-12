part of 'login_bloc.dart';

@immutable
abstract class LoginState {
  const LoginState();
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {

  const LoginSuccessState(this.token);

  final String token;
}

class LoginFailureState extends LoginState {

  const LoginFailureState(this.error);

  final String error;

}
