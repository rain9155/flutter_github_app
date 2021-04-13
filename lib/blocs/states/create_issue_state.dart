part of '../create_issue_bloc.dart';

@immutable
abstract class CreateIssueState {
  const CreateIssueState();
}

class CreateIssueInitialState extends CreateIssueState {}

class GettingDraftIssueState extends CreateIssueState{}

class GetDraftIssueResultState extends CreateIssueState{

  const GetDraftIssueResultState(this.title, this.body);

  final String title;

  final String body;
}
