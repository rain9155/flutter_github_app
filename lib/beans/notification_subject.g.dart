// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationSubject _$NotificationSubjectFromJson(Map<String, dynamic> json) =>
    NotificationSubject()
      ..title = json['title'] as String?
      ..url = json['url'] as String?
      ..latestCommentUrl = json['latest_comment_url'] as String?
      ..type = json['type'] as String?;

Map<String, dynamic> _$NotificationSubjectToJson(
        NotificationSubject instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'latest_comment_url': instance.latestCommentUrl,
      'type': instance.type,
    };
