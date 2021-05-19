part of '../branch_cubit.dart';

@immutable
abstract class BranchState {
  const BranchState();
}

class BranchInitialState extends BranchState {}

class ChangeBranchResultState extends BranchState{

  const ChangeBranchResultState(this.chosenBranch);

  final String? chosenBranch;

}


