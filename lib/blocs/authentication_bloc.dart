import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/utils/shared_preferences_util.dart';

part 'events/authentication_event.dart';
part 'states/authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  static const tag = "AuthenticationBloc";

  AuthenticationBloc(this.userCubit) : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>(mapEventToState, transformer: sequential());
  }

  final UserCubit userCubit;

  FutureOr<void> mapEventToState(AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if(event is AppStartedEvent){
      String? token = await SharedPreferencesUtil.get(KEY_TOKEN);
      if(token != null){
        emit(AuthenticatedState());
      }else{
        emit(UnauthenticatedState());
      }
    }

    if(event is LoggedInEvent){
      SharedPreferencesUtil.setString(KEY_TOKEN, event.token!);
      emit(AuthenticatedState());
    }

    if(event is LoggedOutEvent){
      SharedPreferencesUtil.remove(KEY_TOKEN);
      userCubit.setName(null);
      emit(UnauthenticatedState());
    }
  }
}
