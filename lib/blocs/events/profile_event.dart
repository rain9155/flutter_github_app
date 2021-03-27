part of '../profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent{

  const GetProfileEvent(this.name, this.pageType);

  final String name;

  final int pageType;
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
