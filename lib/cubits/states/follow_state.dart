part of '../follow_cubit.dart';

@immutable
abstract class FollowState {
  const FollowState();
}

class FollowInitialState extends FollowState {}

class FollowingUserState extends FollowState{}

class FollowUserResultState extends FollowState{

  const FollowUserResultState(this.isFollowing);

  final bool isFollowing;

}