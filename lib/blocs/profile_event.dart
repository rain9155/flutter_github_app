part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class GetUserEvent extends ProfileEvent{}

class RefreshedUserEvent extends ProfileEvent{

  const RefreshedUserEvent(this.error);

  final String error;
}

class GetMoreUserEventsEvent extends ProfileEvent{}

