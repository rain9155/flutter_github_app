part of '../contents_bloc.dart';

@immutable
abstract class ContentsEvent {
  const ContentsEvent();
}

class GetContentsEvent extends ContentsEvent{

  const GetContentsEvent(
    this.name,
    this.repoName,
    this.path,
    this.branch
  );

  final String name;

  final String repoName;

  final String path;

  final String branch;
}

class GotContentsEvent extends ContentsEvent{

  const GotContentsEvent({this.errorCode});

  final int errorCode;
}