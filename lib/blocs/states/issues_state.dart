part of '../issues_bloc.dart';

@immutable
abstract class IssuesState {
  const IssuesState();
}

class IssuesInitialState extends IssuesState {}

class GettingIssuesState extends IssuesState{}

class GetIssuesSuccessState extends IssuesState{

  GetIssuesSuccessState(this.issues, this.hasMore);

  final List<Issue> issues;

  final bool hasMore;
}

class GetIssuesFailureState extends GetIssuesSuccessState{

  GetIssuesFailureState(
    List<Issue> issues,
    bool hasMore,
    this.errorCode
  ): super(issues, hasMore);

  final int errorCode;
}

