import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

part 'events/authentication_event.dart';
part 'states/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  static const tag = "AuthenticationBloc";

  AuthenticationBloc(this.userCubit) : super(AuthenticationInitialState());

  final UserCubit userCubit;

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStartedEvent){
      String? token = await SharedPreferencesUtil.get(KEY_TOKEN);
      LogUtil.printString(tag, "mapEventToState: token = $token");
      if(token != null){
        yield AuthenticatedState();
      }else{
        yield UnauthenticatedState();
      }
    }

    if(event is LoggedInEvent){
      LogUtil.printString(tag, "mapEventToState: token = ${event.token}");
      SharedPreferencesUtil.setString(KEY_TOKEN, event.token!);
      yield AuthenticatedState();
    }

    if(event is LoggedOutEvent){
      SharedPreferencesUtil.remove(KEY_TOKEN);
      userCubit.setName(null);
      yield UnauthenticatedState();
    }
  }
}
