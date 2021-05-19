part of '../branches_bloc.dart';

@immutable
abstract class BranchesEvent {
  const BranchesEvent();
}

class GetBranchesEvent extends BranchesEvent{

  const GetBranchesEvent(this.name, this.repoName);

  final String? name;

  final String? repoName;
}

class GotBranchesEvent extends BranchesEvent{

  const GotBranchesEvent({
    this.errorCode
  });

  final int? errorCode;
}
