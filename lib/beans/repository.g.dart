// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository()
  ..id = json['id'] as int?
  ..nodeId = json['node_id'] as String?
  ..name = json['name'] as String?
  ..fullName = json['full_name'] as String?
  ..owner = json['owner'] == null
      ? null
      : Owner.fromJson(json['owner'] as Map<String, dynamic>)
  ..private = json['private'] as bool?
  ..htmlUrl = json['html_url'] as String?
  ..description = json['description'] as String?
  ..fork = json['fork'] as bool?
  ..url = json['url'] as String?
  ..archiveUrl = json['archive_url'] as String?
  ..assigneesUrl = json['assignees_url'] as String?
  ..blobsUrl = json['blobs_url'] as String?
  ..branchesUrl = json['branches_url'] as String?
  ..collaboratorsUrl = json['collaborators_url'] as String?
  ..commentsUrl = json['comments_url'] as String?
  ..commitsUrl = json['commits_url'] as String?
  ..compareUrl = json['compare_url'] as String?
  ..contentsUrl = json['contents_url'] as String?
  ..contributorsUrl = json['contributors_url'] as String?
  ..deploymentsUrl = json['deployments_url'] as String?
  ..downloadsUrl = json['downloads_url'] as String?
  ..eventsUrl = json['events_url'] as String?
  ..forksUrl = json['forks_url'] as String?
  ..gitCommitsUrl = json['git_commits_url'] as String?
  ..gitRefsUrl = json['git_refs_url'] as String?
  ..gitTagsUrl = json['git_tags_url'] as String?
  ..gitUrl = json['git_url'] as String?
  ..issueCommentUrl = json['issue_comment_url'] as String?
  ..issueEventsUrl = json['issue_events_url'] as String?
  ..issuesUrl = json['issues_url'] as String?
  ..keysUrl = json['keys_url'] as String?
  ..labelsUrl = json['labels_url'] as String?
  ..languagesUrl = json['languages_url'] as String?
  ..mergesUrl = json['merges_url'] as String?
  ..milestonesUrl = json['milestones_url'] as String?
  ..notificationsUrl = json['notifications_url'] as String?
  ..pullsUrl = json['pulls_url'] as String?
  ..releasesUrl = json['releases_url'] as String?
  ..sshUrl = json['ssh_url'] as String?
  ..stargazersUrl = json['stargazers_url'] as String?
  ..statusesUrl = json['statuses_url'] as String?
  ..subscribersUrl = json['subscribers_url'] as String?
  ..subscriptionUrl = json['subscription_url'] as String?
  ..tagsUrl = json['tags_url'] as String?
  ..teamsUrl = json['teams_url'] as String?
  ..treesUrl = json['trees_url'] as String?
  ..cloneUrl = json['clone_url'] as String?
  ..mirrorUrl = json['mirror_url'] as String?
  ..hooksUrl = json['hooks_url'] as String?
  ..svnUrl = json['svn_url'] as String?
  ..homepage = json['homepage'] as String?
  ..language = json['language'] as String?
  ..forksCount = json['forks_count'] as int?
  ..stargazersCount = json['stargazers_count'] as int?
  ..watchersCount = json['watchers_count'] as int?
  ..size = json['size'] as int?
  ..defaultBranch = json['default_branch'] as String?
  ..openIssuesCount = json['open_issues_count'] as int?
  ..isTemplate = json['is_template'] as bool?
  ..topics = json['topics'] as List<dynamic>?
  ..hasIssues = json['has_issues'] as bool?
  ..hasProjects = json['has_projects'] as bool?
  ..hasWiki = json['has_wiki'] as bool?
  ..hasPages = json['has_pages'] as bool?
  ..hasDownloads = json['has_downloads'] as bool?
  ..archived = json['archived'] as bool?
  ..disabled = json['disabled'] as bool?
  ..visibility = json['visibility'] as String?
  ..pushedAt = json['pushed_at'] as String?
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?
  ..permissions = json['permissions'] as Map<String, dynamic>?
  ..allowRebaseMerge = json['allow_rebase_merge'] as bool?
  ..templateRepository = json['template_repository'] as String?
  ..tempCloneToken = json['temp_clone_token'] as String?
  ..allowSquashMerge = json['allow_squash_merge'] as bool?
  ..deleteBranchOnMerge = json['delete_branch_on_merge'] as bool?
  ..allowMergeCommit = json['allow_merge_commit'] as bool?
  ..subscribersCount = json['subscribers_count'] as int?
  ..networkCount = json['network_count'] as int?
  ..license = json['license'] == null
      ? null
      : License.fromJson(json['license'] as Map<String, dynamic>)
  ..forks = json['forks'] as int?
  ..openIssues = json['open_issues'] as int?
  ..watchers = json['watchers'] as int?;

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'id': instance.id,
      'node_id': instance.nodeId,
      'name': instance.name,
      'full_name': instance.fullName,
      'owner': instance.owner,
      'private': instance.private,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'fork': instance.fork,
      'url': instance.url,
      'archive_url': instance.archiveUrl,
      'assignees_url': instance.assigneesUrl,
      'blobs_url': instance.blobsUrl,
      'branches_url': instance.branchesUrl,
      'collaborators_url': instance.collaboratorsUrl,
      'comments_url': instance.commentsUrl,
      'commits_url': instance.commitsUrl,
      'compare_url': instance.compareUrl,
      'contents_url': instance.contentsUrl,
      'contributors_url': instance.contributorsUrl,
      'deployments_url': instance.deploymentsUrl,
      'downloads_url': instance.downloadsUrl,
      'events_url': instance.eventsUrl,
      'forks_url': instance.forksUrl,
      'git_commits_url': instance.gitCommitsUrl,
      'git_refs_url': instance.gitRefsUrl,
      'git_tags_url': instance.gitTagsUrl,
      'git_url': instance.gitUrl,
      'issue_comment_url': instance.issueCommentUrl,
      'issue_events_url': instance.issueEventsUrl,
      'issues_url': instance.issuesUrl,
      'keys_url': instance.keysUrl,
      'labels_url': instance.labelsUrl,
      'languages_url': instance.languagesUrl,
      'merges_url': instance.mergesUrl,
      'milestones_url': instance.milestonesUrl,
      'notifications_url': instance.notificationsUrl,
      'pulls_url': instance.pullsUrl,
      'releases_url': instance.releasesUrl,
      'ssh_url': instance.sshUrl,
      'stargazers_url': instance.stargazersUrl,
      'statuses_url': instance.statusesUrl,
      'subscribers_url': instance.subscribersUrl,
      'subscription_url': instance.subscriptionUrl,
      'tags_url': instance.tagsUrl,
      'teams_url': instance.teamsUrl,
      'trees_url': instance.treesUrl,
      'clone_url': instance.cloneUrl,
      'mirror_url': instance.mirrorUrl,
      'hooks_url': instance.hooksUrl,
      'svn_url': instance.svnUrl,
      'homepage': instance.homepage,
      'language': instance.language,
      'forks_count': instance.forksCount,
      'stargazers_count': instance.stargazersCount,
      'watchers_count': instance.watchersCount,
      'size': instance.size,
      'default_branch': instance.defaultBranch,
      'open_issues_count': instance.openIssuesCount,
      'is_template': instance.isTemplate,
      'topics': instance.topics,
      'has_issues': instance.hasIssues,
      'has_projects': instance.hasProjects,
      'has_wiki': instance.hasWiki,
      'has_pages': instance.hasPages,
      'has_downloads': instance.hasDownloads,
      'archived': instance.archived,
      'disabled': instance.disabled,
      'visibility': instance.visibility,
      'pushed_at': instance.pushedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'permissions': instance.permissions,
      'allow_rebase_merge': instance.allowRebaseMerge,
      'template_repository': instance.templateRepository,
      'temp_clone_token': instance.tempCloneToken,
      'allow_squash_merge': instance.allowSquashMerge,
      'delete_branch_on_merge': instance.deleteBranchOnMerge,
      'allow_merge_commit': instance.allowMergeCommit,
      'subscribers_count': instance.subscribersCount,
      'network_count': instance.networkCount,
      'license': instance.license,
      'forks': instance.forks,
      'open_issues': instance.openIssues,
      'watchers': instance.watchers,
    };
