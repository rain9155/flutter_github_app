part of '../submit_issue_cubit.dart';

@immutable
abstract class SubmitIssueState {
  const SubmitIssueState();
}

class SubmitIssueInitialState extends SubmitIssueState {}

class SubmittingIssueState extends SubmitIssueState{}

class SubmitIssueResultState extends SubmitIssueState{

  const SubmitIssueResultState({
    this.issue,
    this.errorCode
  });

  final Issue issue;

  final int errorCode;
}
