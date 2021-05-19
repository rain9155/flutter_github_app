part of '../pulls_bloc.dart';

@immutable
abstract class PullsEvent {
  const PullsEvent();
}

class GetPullsEvent extends PullsEvent{

  const GetPullsEvent(
    this.name,
    this.repoName,
    this.pageType
  );

  final String? name;

  final String? repoName;

  final int pageType;
}

class GotPullsEvent extends PullsEvent{

  const GotPullsEvent({this.errorCode});

  final int? errorCode;
}