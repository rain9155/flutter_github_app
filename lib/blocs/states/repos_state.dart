part of '../repos_bloc.dart';

@immutable
abstract class ReposState {
  const ReposState();
}

class ReposInitialState extends ReposState {}

class GettingReposState extends ReposState{}

class GetReposSuccessState extends ReposState{

  const GetReposSuccessState(this.repositories, this.hasMore);

  final List<Repository> repositories;

  final bool hasMore;
}

class GetReposFailureState extends GetReposSuccessState{

  const GetReposFailureState(
    List<Repository> repositories,
    bool hasMore,
    this.errorCode
  ): super(repositories, hasMore);

  final int errorCode;
}

