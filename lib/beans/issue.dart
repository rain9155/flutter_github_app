import 'package:json_annotation/json_annotation.dart';

import "owner.dart";
import "label.dart";
import "milestone.dart";
import "pull.dart";
import "repository.dart";

part 'issue.g.dart';

@JsonSerializable()
class Issue {

  Issue();

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'node_id')
  String? nodeId;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'repository_url')
  String? repositoryUrl;
  @JsonKey(name: 'labels_url')
  String? labelsUrl;
  @JsonKey(name: 'comments_url')
  String? commentsUrl;
  @JsonKey(name: 'events_url')
  String? eventsUrl;
  @JsonKey(name: 'html_url')
  String? htmlUrl;
  @JsonKey(name: 'number')
  int? number;
  @JsonKey(name: 'state')
  String? state;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'body')
  String? body;
  @JsonKey(name: 'user')
  Owner? user;
  @JsonKey(name: 'labels')
  List<Label>? labels;
  @JsonKey(name: 'assignee')
  Owner? assignee;
  @JsonKey(name: 'assignees')
  List<Owner>? assignees;
  @JsonKey(name: 'milestone')
  Milestone? milestone;
  @JsonKey(name: 'locked')
  bool? locked;
  @JsonKey(name: 'active_lock_reason')
  String? activeLockReason;
  @JsonKey(name: 'comments')
  int? comments;
  @JsonKey(name: 'pull_request')
  Pull? pullRequest;
  @JsonKey(name: 'closed_at')
  String? closedAt;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'repository')
  Repository? repository;
  @JsonKey(name: 'author_association')
  String? authorAssociation;
  

  factory Issue.fromJson(Map<String,dynamic> json) => _$IssueFromJson(json);

  Map<String, dynamic> toJson() => _$IssueToJson(this);

}