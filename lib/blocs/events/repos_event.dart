part of '../repos_bloc.dart';

@immutable
abstract class ReposEvent {
  const ReposEvent();
}

class GetReposEvent extends ReposEvent{

  const GetReposEvent(this.name, this.repoName, this.routeType);

  final String? name;

  final String? repoName;

  final int? routeType;

}

class GotReposEvent extends ReposEvent{

  const GotReposEvent({
    this.errorCode
  });

  final int? errorCode;
}



