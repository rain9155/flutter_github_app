part of '../commits_bloc.dart';

@immutable
abstract class CommitsState {
  const CommitsState();
}

class CommitsInitialState extends CommitsState {}

class GettingCommitsState extends CommitsState{}

class GetCommitsSuccessState extends CommitsState{

  const GetCommitsSuccessState(this.commits, this.hasMore);

  final List<Commit> commits;

  final bool hasMore;
}

class GetCommitsFailureState extends GetCommitsSuccessState{

  const GetCommitsFailureState(
      List<Commit> commits,
      bool hasMore,
      this.errorCode
      ): super(commits, hasMore);

  final int errorCode;
}