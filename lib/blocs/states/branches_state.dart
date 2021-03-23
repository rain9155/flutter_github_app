part of '../branches_bloc.dart';

@immutable
abstract class BranchesState {
  const BranchesState();
}

class BranchesInitialState extends BranchesState {}

class GettingBranchesState extends BranchesState{}

class GetBranchesSuccessState extends BranchesState{

  const GetBranchesSuccessState(this.branches, this.hasMore);

  final List<Branch> branches;

  final bool hasMore;
}

class GetBranchesFailureState extends GetBranchesSuccessState{

  const GetBranchesFailureState(
    List<Branch> branches,
    bool hasMore,
    this.errorCode
  ): super(branches, hasMore);

  final int errorCode;
}

