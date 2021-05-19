part of '../repo_bloc.dart';

@immutable
abstract class RepoEvent {
  const RepoEvent();
}

class GetRepoEvent extends RepoEvent{

  const GetRepoEvent(this.url, this.name, this.repoName);

  final String? url;

  final String? name;

  final String? repoName;
}

class GotRepoEvent extends RepoEvent{

  const GotRepoEvent({this.errorCode});

  final int? errorCode;
}

class StarRepoEvent extends RepoEvent{

  const StarRepoEvent(this.star);

  final bool star;

}

class ChangeBranchEvent extends RepoEvent{

  const ChangeBranchEvent(this.branch);

  final String? branch;
}

class UpdateReadmeEvent extends RepoEvent{}
