import 'package:json_annotation/json_annotation.dart';

import "notification_repo_owner.dart";

part 'notification_repo.g.dart';

@JsonSerializable()
class NotificationRepo {

  NotificationRepo();

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'full_name')
  String fullName;
  @JsonKey(name: 'private')
  bool private;
  @JsonKey(name: 'owner')
  NotificationRepoOwner owner;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'fork')
  bool fork;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'forks_url')
  String forksUrl;
  @JsonKey(name: 'keys_url')
  String keysUrl;
  @JsonKey(name: 'collaborators_url')
  String collaboratorsUrl;
  @JsonKey(name: 'teams_url')
  String teamsUrl;
  @JsonKey(name: 'hooks_url')
  String hooksUrl;
  @JsonKey(name: 'issue_events_url')
  String issueEventsUrl;
  @JsonKey(name: 'events_url')
  String eventsUrl;
  @JsonKey(name: 'assignees_url')
  String assigneesUrl;
  @JsonKey(name: 'branches_url')
  String branchesUrl;
  @JsonKey(name: 'tags_url')
  String tagsUrl;
  @JsonKey(name: 'blobs_url')
  String blobsUrl;
  @JsonKey(name: 'git_tags_url')
  String gitTagsUrl;
  @JsonKey(name: 'git_refs_url')
  String gitRefsUrl;
  @JsonKey(name: 'trees_url')
  String treesUrl;
  @JsonKey(name: 'statuses_url')
  String statusesUrl;
  @JsonKey(name: 'languages_url')
  String languagesUrl;
  @JsonKey(name: 'stargazers_url')
  String stargazersUrl;
  @JsonKey(name: 'contributors_url')
  String contributorsUrl;
  @JsonKey(name: 'subscribers_url')
  String subscribersUrl;
  @JsonKey(name: 'subscription_url')
  String subscriptionUrl;
  @JsonKey(name: 'commits_url')
  String commitsUrl;
  @JsonKey(name: 'git_commits_url')
  String gitCommitsUrl;
  @JsonKey(name: 'comments_url')
  String commentsUrl;
  @JsonKey(name: 'issue_comment_url')
  String issueCommentUrl;
  @JsonKey(name: 'contents_url')
  String contentsUrl;
  @JsonKey(name: 'compare_url')
  String compareUrl;
  @JsonKey(name: 'merges_url')
  String mergesUrl;
  @JsonKey(name: 'archive_url')
  String archiveUrl;
  @JsonKey(name: 'downloads_url')
  String downloadsUrl;
  @JsonKey(name: 'issues_url')
  String issuesUrl;
  @JsonKey(name: 'pulls_url')
  String pullsUrl;
  @JsonKey(name: 'milestones_url')
  String milestonesUrl;
  @JsonKey(name: 'notifications_url')
  String notificationsUrl;
  @JsonKey(name: 'labels_url')
  String labelsUrl;
  @JsonKey(name: 'releases_url')
  String releasesUrl;
  @JsonKey(name: 'deployments_url')
  String deploymentsUrl;
  

  factory NotificationRepo.fromJson(Map<String,dynamic> json) => _$NotificationRepoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationRepoToJson(this);

}