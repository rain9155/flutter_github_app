part of '../profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent{

  const GetProfileEvent(this.name, this.routeType);

  final String name;

  final int routeType;
}

class GotProfileEvent extends ProfileEvent{

  const GotProfileEvent({
    this.errorCode
  });

  final int errorCode;
}

class FollowUserEvent extends ProfileEvent{

  const FollowUserEvent(this.isFollow);

  final bool isFollow;
}
