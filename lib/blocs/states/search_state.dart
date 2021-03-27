part of '../search_bloc.dart';

@immutable
abstract class SearchState {
  const SearchState();
}

class SearchInitialState extends SearchState {}

class ShowHistoriesState extends SearchState{

  const ShowHistoriesState(this.histories);

  final List<String> histories;
}

class ShowGuidesState extends SearchState{}

class SearchingState extends SearchState{}

class SearchSuccessState extends SearchState{

  const SearchSuccessState({
    this.issues,
    this.pulls,
    this.users,
    this.orgs,
    this.repos,
    this.totalIssuesCount,
    this.totalPullsCount,
    this.totalOrgsCount,
    this.totalUsersCount,
    this.totalReposCount
  });

  final List<Issue> issues;

  final int totalIssuesCount;

  final List<Issue> pulls;

  final int totalPullsCount;

  final List<Owner> users;

  final int totalUsersCount;

  final List<Owner> orgs;

  final int totalOrgsCount;

  final List<Repository> repos;

  final int totalReposCount;
}

class SearchFailureState extends SearchState{

  const SearchFailureState(this.errorCode);

  final int errorCode;
}

