import 'package:json_annotation/json_annotation.dart';

import "owner.dart";
import "license.dart";

part 'repository.g.dart';

@JsonSerializable()
class Repository {

  Repository();

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'node_id')
  String? nodeId;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'full_name')
  String? fullName;
  @JsonKey(name: 'owner')
  Owner? owner;
  @JsonKey(name: 'private')
  bool? private;
  @JsonKey(name: 'html_url')
  String? htmlUrl;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'fork')
  bool? fork;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'archive_url')
  String? archiveUrl;
  @JsonKey(name: 'assignees_url')
  String? assigneesUrl;
  @JsonKey(name: 'blobs_url')
  String? blobsUrl;
  @JsonKey(name: 'branches_url')
  String? branchesUrl;
  @JsonKey(name: 'collaborators_url')
  String? collaboratorsUrl;
  @JsonKey(name: 'comments_url')
  String? commentsUrl;
  @JsonKey(name: 'commits_url')
  String? commitsUrl;
  @JsonKey(name: 'compare_url')
  String? compareUrl;
  @JsonKey(name: 'contents_url')
  String? contentsUrl;
  @JsonKey(name: 'contributors_url')
  String? contributorsUrl;
  @JsonKey(name: 'deployments_url')
  String? deploymentsUrl;
  @JsonKey(name: 'downloads_url')
  String? downloadsUrl;
  @JsonKey(name: 'events_url')
  String? eventsUrl;
  @JsonKey(name: 'forks_url')
  String? forksUrl;
  @JsonKey(name: 'git_commits_url')
  String? gitCommitsUrl;
  @JsonKey(name: 'git_refs_url')
  String? gitRefsUrl;
  @JsonKey(name: 'git_tags_url')
  String? gitTagsUrl;
  @JsonKey(name: 'git_url')
  String? gitUrl;
  @JsonKey(name: 'issue_comment_url')
  String? issueCommentUrl;
  @JsonKey(name: 'issue_events_url')
  String? issueEventsUrl;
  @JsonKey(name: 'issues_url')
  String? issuesUrl;
  @JsonKey(name: 'keys_url')
  String? keysUrl;
  @JsonKey(name: 'labels_url')
  String? labelsUrl;
  @JsonKey(name: 'languages_url')
  String? languagesUrl;
  @JsonKey(name: 'merges_url')
  String? mergesUrl;
  @JsonKey(name: 'milestones_url')
  String? milestonesUrl;
  @JsonKey(name: 'notifications_url')
  String? notificationsUrl;
  @JsonKey(name: 'pulls_url')
  String? pullsUrl;
  @JsonKey(name: 'releases_url')
  String? releasesUrl;
  @JsonKey(name: 'ssh_url')
  String? sshUrl;
  @JsonKey(name: 'stargazers_url')
  String? stargazersUrl;
  @JsonKey(name: 'statuses_url')
  String? statusesUrl;
  @JsonKey(name: 'subscribers_url')
  String? subscribersUrl;
  @JsonKey(name: 'subscription_url')
  String? subscriptionUrl;
  @JsonKey(name: 'tags_url')
  String? tagsUrl;
  @JsonKey(name: 'teams_url')
  String? teamsUrl;
  @JsonKey(name: 'trees_url')
  String? treesUrl;
  @JsonKey(name: 'clone_url')
  String? cloneUrl;
  @JsonKey(name: 'mirror_url')
  String? mirrorUrl;
  @JsonKey(name: 'hooks_url')
  String? hooksUrl;
  @JsonKey(name: 'svn_url')
  String? svnUrl;
  @JsonKey(name: 'homepage')
  String? homepage;
  @JsonKey(name: 'language')
  String? language;
  @JsonKey(name: 'forks_count')
  int? forksCount;
  @JsonKey(name: 'stargazers_count')
  int? stargazersCount;
  @JsonKey(name: 'watchers_count')
  int? watchersCount;
  @JsonKey(name: 'size')
  int? size;
  @JsonKey(name: 'default_branch')
  String? defaultBranch;
  @JsonKey(name: 'open_issues_count')
  int? openIssuesCount;
  @JsonKey(name: 'is_template')
  bool? isTemplate;
  @JsonKey(name: 'topics')
  List<dynamic>? topics;
  @JsonKey(name: 'has_issues')
  bool? hasIssues;
  @JsonKey(name: 'has_projects')
  bool? hasProjects;
  @JsonKey(name: 'has_wiki')
  bool? hasWiki;
  @JsonKey(name: 'has_pages')
  bool? hasPages;
  @JsonKey(name: 'has_downloads')
  bool? hasDownloads;
  @JsonKey(name: 'archived')
  bool? archived;
  @JsonKey(name: 'disabled')
  bool? disabled;
  @JsonKey(name: 'visibility')
  String? visibility;
  @JsonKey(name: 'pushed_at')
  String? pushedAt;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'permissions')
  Map<String,dynamic>? permissions;
  @JsonKey(name: 'allow_rebase_merge')
  bool? allowRebaseMerge;
  @JsonKey(name: 'template_repository')
  String? templateRepository;
  @JsonKey(name: 'temp_clone_token')
  String? tempCloneToken;
  @JsonKey(name: 'allow_squash_merge')
  bool? allowSquashMerge;
  @JsonKey(name: 'delete_branch_on_merge')
  bool? deleteBranchOnMerge;
  @JsonKey(name: 'allow_merge_commit')
  bool? allowMergeCommit;
  @JsonKey(name: 'subscribers_count')
  int? subscribersCount;
  @JsonKey(name: 'network_count')
  int? networkCount;
  @JsonKey(name: 'license')
  License? license;
  @JsonKey(name: 'forks')
  int? forks;
  @JsonKey(name: 'open_issues')
  int? openIssues;
  @JsonKey(name: 'watchers')
  int? watchers;
  

  factory Repository.fromJson(Map<String,dynamic> json) => _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);

}