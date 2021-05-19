part of '../repo_bloc.dart';

@immutable
abstract class RepoState {
  const RepoState();
}

class RepoInitialState extends RepoState {}

class GettingRepoState extends RepoState {}

class GetRepoSuccessState extends RepoState {

  const GetRepoSuccessState(
    this.repository,
    this.isStarred,
    this.branch,
    this.readmd
  );

  final Repository? repository;

  final bool? isStarred;

  final String? branch;

  final String? readmd;
}

class GetRepoFailureState extends GetRepoSuccessState {

  const GetRepoFailureState(
    Repository? repository,
    bool? isStarred,
    String? branch,
    String? readmd,
    this.errorCode
  ): super(repository, isStarred, branch, readmd);

  final int? errorCode;
}



