part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {}

class GettingUserState extends ProfileState{}

class GetUserSuccessState extends ProfileState{

  const GetUserSuccessState(this.user, this.events, this.increasedCount);

  final User user;

  final List<Event> events;

  final int increasedCount;
}

class GetUserFailureState extends ProfileState{

  const GetUserFailureState(this.isGetMore, this.user, this.events, this.error);

  final bool isGetMore;

  final User user;

  final List<Event> events;

  final String error;
}