// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pull _$PullFromJson(Map<String, dynamic> json) => Pull()
  ..url = json['url'] as String?
  ..id = json['id'] as int?
  ..nodeId = json['node_id'] as String?
  ..htmlUrl = json['html_url'] as String?
  ..diffUrl = json['diff_url'] as String?
  ..patchUrl = json['patch_url'] as String?
  ..issueUrl = json['issue_url'] as String?
  ..commitsUrl = json['commits_url'] as String?
  ..reviewCommentsUrl = json['review_comments_url'] as String?
  ..reviewCommentUrl = json['review_comment_url'] as String?
  ..commentsUrl = json['comments_url'] as String?
  ..statusesUrl = json['statuses_url'] as String?
  ..number = json['number'] as int?
  ..state = json['state'] as String?
  ..locked = json['locked'] as bool?
  ..title = json['title'] as String?
  ..user = json['user'] == null
      ? null
      : Owner.fromJson(json['user'] as Map<String, dynamic>)
  ..body = json['body'] as String?
  ..labels = (json['labels'] as List<dynamic>?)
      ?.map((e) => Label.fromJson(e as Map<String, dynamic>))
      .toList()
  ..milestone = json['milestone'] == null
      ? null
      : Milestone.fromJson(json['milestone'] as Map<String, dynamic>)
  ..activeLockReason = json['active_lock_reason'] as String?
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?
  ..closedAt = json['closed_at'] as String?
  ..mergedAt = json['merged_at'] as String?
  ..mergeCommitSha = json['merge_commit_sha'] as String?
  ..assignee = json['assignee'] == null
      ? null
      : Owner.fromJson(json['assignee'] as Map<String, dynamic>)
  ..assignees = (json['assignees'] as List<dynamic>?)
      ?.map((e) => Owner.fromJson(e as Map<String, dynamic>))
      .toList()
  ..requestedReviewers = (json['requested_reviewers'] as List<dynamic>?)
      ?.map((e) => Owner.fromJson(e as Map<String, dynamic>))
      .toList()
  ..requestedTeams = json['requested_teams'] as List<dynamic>?
  ..head = json['head'] as Map<String, dynamic>?
  ..base = json['base'] as Map<String, dynamic>?
  ..authorAssociation = json['author_association'] as String?
  ..autoMerge = json['auto_merge'] as String?
  ..draft = json['draft'] as bool?;

Map<String, dynamic> _$PullToJson(Pull instance) => <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'node_id': instance.nodeId,
      'html_url': instance.htmlUrl,
      'diff_url': instance.diffUrl,
      'patch_url': instance.patchUrl,
      'issue_url': instance.issueUrl,
      'commits_url': instance.commitsUrl,
      'review_comments_url': instance.reviewCommentsUrl,
      'review_comment_url': instance.reviewCommentUrl,
      'comments_url': instance.commentsUrl,
      'statuses_url': instance.statusesUrl,
      'number': instance.number,
      'state': instance.state,
      'locked': instance.locked,
      'title': instance.title,
      'user': instance.user,
      'body': instance.body,
      'labels': instance.labels,
      'milestone': instance.milestone,
      'active_lock_reason': instance.activeLockReason,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'closed_at': instance.closedAt,
      'merged_at': instance.mergedAt,
      'merge_commit_sha': instance.mergeCommitSha,
      'assignee': instance.assignee,
      'assignees': instance.assignees,
      'requested_reviewers': instance.requestedReviewers,
      'requested_teams': instance.requestedTeams,
      'head': instance.head,
      'base': instance.base,
      'author_association': instance.authorAssociation,
      'auto_merge': instance.autoMerge,
      'draft': instance.draft,
    };
