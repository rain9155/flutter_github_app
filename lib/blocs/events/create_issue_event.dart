part of '../create_issue_bloc.dart';

@immutable
abstract class CreateIssueEvent {
  const CreateIssueEvent();
}

class GetDraftIssueEvent extends CreateIssueEvent{

  const GetDraftIssueEvent(this.name, this.repoName);

  final String? name;

  final String? repoName;
}

class SaveDraftIssueEvent extends CreateIssueEvent{

  const SaveDraftIssueEvent(this.title, this.body);

  final String? title;

  final String? body;
}

class SubmitCreateIssueEvent extends CreateIssueEvent{

  const SubmitCreateIssueEvent(this.title, this.body);

  final String title;

  final String body;
}

