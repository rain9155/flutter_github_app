part of '../commits_bloc.dart';

@immutable
abstract class CommitsEvent {
  const CommitsEvent();
}


class GetCommitsEvent extends CommitsEvent{

  const GetCommitsEvent(
    this.name,
    this.repoName,
    this.branch
  );

  final String? name;

  final String? repoName;

  final String? branch;
}

class GotCommitsEvent extends CommitsEvent{

  const GotCommitsEvent({this.errorCode});

  final int? errorCode;
}

