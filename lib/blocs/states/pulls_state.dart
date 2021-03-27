part of '../pulls_bloc.dart';

@immutable
abstract class PullsState {
  const PullsState();
}

class PullsInitialState extends PullsState {}

class GettingPullsState extends PullsState{}

class GetPullsSuccessState extends PullsState{

  const GetPullsSuccessState(this.pulls, this.hasMore);

  final List<Pull> pulls;

  final bool hasMore;
}

class GetPullsFailureState extends GetPullsSuccessState{

  const GetPullsFailureState(
    List<Pull> pulls,
    bool hasMore,
    this.errorCode
  ): super(pulls, hasMore);

  final int errorCode;
}