import 'package:json_annotation/json_annotation.dart';

import "owner.dart";
import "label.dart";
import "milestone.dart";

part 'pull.g.dart';

@JsonSerializable()
class Pull {

  Pull();

  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'diff_url')
  String diffUrl;
  @JsonKey(name: 'patch_url')
  String patchUrl;
  @JsonKey(name: 'issue_url')
  String issueUrl;
  @JsonKey(name: 'commits_url')
  String commitsUrl;
  @JsonKey(name: 'review_comments_url')
  String reviewCommentsUrl;
  @JsonKey(name: 'review_comment_url')
  String reviewCommentUrl;
  @JsonKey(name: 'comments_url')
  String commentsUrl;
  @JsonKey(name: 'statuses_url')
  String statusesUrl;
  @JsonKey(name: 'number')
  int number;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'locked')
  bool locked;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'user')
  Owner user;
  @JsonKey(name: 'body')
  String body;
  @JsonKey(name: 'labels')
  List<Label> labels;
  @JsonKey(name: 'milestone')
  Milestone milestone;
  @JsonKey(name: 'active_lock_reason')
  String activeLockReason;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'closed_at')
  String closedAt;
  @JsonKey(name: 'merged_at')
  String mergedAt;
  @JsonKey(name: 'merge_commit_sha')
  String mergeCommitSha;
  @JsonKey(name: 'assignee')
  Owner assignee;
  @JsonKey(name: 'assignees')
  List<Owner> assignees;
  @JsonKey(name: 'requested_reviewers')
  List<Owner> requestedReviewers;
  @JsonKey(name: 'requested_teams')
  List<dynamic> requestedTeams;
  @JsonKey(name: 'head')
  Map<String,dynamic> head;
  @JsonKey(name: 'base')
  Map<String,dynamic> base;
  @JsonKey(name: 'author_association')
  String authorAssociation;
  @JsonKey(name: 'auto_merge')
  String autoMerge;
  @JsonKey(name: 'draft')
  bool draft;
  

  factory Pull.fromJson(Map<String,dynamic> json) => _$PullFromJson(json);

  Map<String, dynamic> toJson() => _$PullToJson(this);

}