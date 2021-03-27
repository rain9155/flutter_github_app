part of '../issues_bloc.dart';

@immutable
abstract class IssuesEvent {
  const IssuesEvent();
}

class GetIssuesEvent extends IssuesEvent{

  const GetIssuesEvent(
    this.name,
    this.repoName,
    this.pageType
  );

  final String name;

  final String repoName;

  final int pageType;
}

class GotIssuesEvent extends IssuesEvent{

  const GotIssuesEvent({this.errorCode});

  final int errorCode;
}

