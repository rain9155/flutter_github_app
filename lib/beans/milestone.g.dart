// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Milestone _$MilestoneFromJson(Map<String, dynamic> json) {
  return Milestone()
    ..url = json['url'] as String?
    ..htmlUrl = json['html_url'] as String?
    ..labelsUrl = json['labels_url'] as String?
    ..id = json['id'] as int?
    ..nodeId = json['node_id'] as String?
    ..number = json['number'] as int?
    ..state = json['state'] as String?
    ..title = json['title'] as String?
    ..description = json['description'] as String?
    ..creator = json['creator'] == null
        ? null
        : Owner.fromJson(json['creator'] as Map<String, dynamic>)
    ..openIssues = json['open_issues'] as int?
    ..closedIssues = json['closed_issues'] as int?
    ..createdAt = json['created_at'] as String?
    ..updatedAt = json['updated_at'] as String?
    ..closedAt = json['closed_at'] as String?
    ..dueOn = json['due_on'] as String?;
}

Map<String, dynamic> _$MilestoneToJson(Milestone instance) => <String, dynamic>{
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'labels_url': instance.labelsUrl,
      'id': instance.id,
      'node_id': instance.nodeId,
      'number': instance.number,
      'state': instance.state,
      'title': instance.title,
      'description': instance.description,
      'creator': instance.creator,
      'open_issues': instance.openIssues,
      'closed_issues': instance.closedIssues,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'closed_at': instance.closedAt,
      'due_on': instance.dueOn,
    };
