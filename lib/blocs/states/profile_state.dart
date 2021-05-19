part of '../profile_bloc.dart';

@immutable
abstract class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {}

class GettingProfileState extends ProfileState{}

class GetProfileSuccessState extends ProfileState{

  const GetProfileSuccessState(this.profile, this.isFollowing, this.events, this.hasMore);

  final Profile? profile;

  final bool? isFollowing;

  final List<Event>? events;

  final bool hasMore;
}

class GetProfileFailureState extends GetProfileSuccessState{

  const GetProfileFailureState(
    Profile? profile,
    bool? isFollowing,
    List<Event>? events,
    bool hasMore,
    this.errorCode
  ): super(profile, isFollowing, events, hasMore);

  final int? errorCode;
}
