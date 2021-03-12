// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRepo _$NotificationRepoFromJson(Map<String, dynamic> json) {
  return NotificationRepo()
    ..id = json['id'] as int
    ..nodeId = json['node_id'] as String
    ..name = json['name'] as String
    ..fullName = json['full_name'] as String
    ..private = json['private'] as bool
    ..owner = json['owner'] == null
        ? null
        : NotificationRepoOwner.fromJson(json['owner'] as Map<String, dynamic>)
    ..htmlUrl = json['html_url'] as String
    ..description = json['description'] as String
    ..fork = json['fork'] as bool
    ..url = json['url'] as String
    ..forksUrl = json['forks_url'] as String
    ..keysUrl = json['keys_url'] as String
    ..collaboratorsUrl = json['collaborators_url'] as String
    ..teamsUrl = json['teams_url'] as String
    ..hooksUrl = json['hooks_url'] as String
    ..issueEventsUrl = json['issue_events_url'] as String
    ..eventsUrl = json['events_url'] as String
    ..assigneesUrl = json['assignees_url'] as String
    ..branchesUrl = json['branches_url'] as String
    ..tagsUrl = json['tags_url'] as String
    ..blobsUrl = json['blobs_url'] as String
    ..gitTagsUrl = json['git_tags_url'] as String
    ..gitRefsUrl = json['git_refs_url'] as String
    ..treesUrl = json['trees_url'] as String
    ..statusesUrl = json['statuses_url'] as String
    ..languagesUrl = json['languages_url'] as String
    ..stargazersUrl = json['stargazers_url'] as String
    ..contributorsUrl = json['contributors_url'] as String
    ..subscribersUrl = json['subscribers_url'] as String
    ..subscriptionUrl = json['subscription_url'] as String
    ..commitsUrl = json['commits_url'] as String
    ..gitCommitsUrl = json['git_commits_url'] as String
    ..commentsUrl = json['comments_url'] as String
    ..issueCommentUrl = json['issue_comment_url'] as String
    ..contentsUrl = json['contents_url'] as String
    ..compareUrl = json['compare_url'] as String
    ..mergesUrl = json['merges_url'] as String
    ..archiveUrl = json['archive_url'] as String
    ..downloadsUrl = json['downloads_url'] as String
    ..issuesUrl = json['issues_url'] as String
    ..pullsUrl = json['pulls_url'] as String
    ..milestonesUrl = json['milestones_url'] as String
    ..notificationsUrl = json['notifications_url'] as String
    ..labelsUrl = json['labels_url'] as String
    ..releasesUrl = json['releases_url'] as String
    ..deploymentsUrl = json['deployments_url'] as String;
}

Map<String, dynamic> _$NotificationRepoToJson(NotificationRepo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'name': instance.name,
      'full_name': instance.fullName,
      'private': instance.private,
      'owner': instance.owner,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'url': instance.url,
      'forks_url': instance.forksUrl,
      'keys_url': instance.keysUrl,
      'collaborators_url': instance.collaboratorsUrl,
      'teams_url': instance.teamsUrl,
      'hooks_url': instance.hooksUrl,
      'issue_events_url': instance.issueEventsUrl,
      'events_url': instance.eventsUrl,
      'assignees_url': instance.assigneesUrl,
      'branches_url': instance.branchesUrl,
      'tags_url': instance.tagsUrl,
      'blobs_url': instance.blobsUrl,
      'git_tags_url': instance.gitTagsUrl,
      'git_refs_url': instance.gitRefsUrl,
      'trees_url': instance.treesUrl,
      'statuses_url': instance.statusesUrl,
      'languages_url': instance.languagesUrl,
      'stargazers_url': instance.stargazersUrl,
      'contributors_url': instance.contributorsUrl,
      'subscribers_url': instance.subscribersUrl,
      'subscription_url': instance.subscriptionUrl,
      'commits_url': instance.commitsUrl,
      'git_commits_url': instance.gitCommitsUrl,
      'comments_url': instance.commentsUrl,
      'issue_comment_url': instance.issueCommentUrl,
      'contents_url': instance.contentsUrl,
      'compare_url': instance.compareUrl,
      'merges_url': instance.mergesUrl,
      'archive_url': instance.archiveUrl,
      'downloads_url': instance.downloadsUrl,
      'issues_url': instance.issuesUrl,
      'pulls_url': instance.pullsUrl,
      'milestones_url': instance.milestonesUrl,
      'notifications_url': instance.notificationsUrl,
      'labels_url': instance.labelsUrl,
      'releases_url': instance.releasesUrl,
      'deployments_url': instance.deploymentsUrl,
    };
