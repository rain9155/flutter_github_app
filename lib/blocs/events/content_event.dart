part of '../content_bloc.dart';

@immutable
abstract class ContentEvent {
  const ContentEvent();
}

class GetContentEvent extends ContentEvent{

  const GetContentEvent(
    this.name,
    this.repoName,
    this.path,
    this.branch
  );

  final String? name;

  final String? repoName;

  final String? path;

  final String? branch;
}

class GotContentEvent extends ContentEvent{

  const GotContentEvent({this.errorCode});

  final int? errorCode;
}
