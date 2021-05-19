part of '../searches_bloc.dart';

@immutable
abstract class SearchesState {
  const SearchesState();
}

class SearchesInitialState extends SearchesState {}

class GettingSearchesState extends SearchesState{}

class GetSearchesSuccessState extends SearchesState{

  const GetSearchesSuccessState({
    this.issues,
    this.users,
    this.repos,
    this.hasMore,
  });

  final List<Issue>? issues;

  final List<Owner>? users;

  final List<Repository>? repos;

  final bool? hasMore;
}

class GetSearchesFailureState extends GetSearchesSuccessState{

  const GetSearchesFailureState(this.errorCode, {
    List<Issue>? issues,
    List<Owner>? users,
    List<Repository>? repos,
    bool? hasMore,
  }): super(issues: issues, users: users, repos: repos, hasMore: hasMore);

  final int? errorCode;
}