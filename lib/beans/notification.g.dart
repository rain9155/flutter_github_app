// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification()
    ..id = json['id'] as String?
    ..unread = json['unread'] as bool?
    ..reason = json['reason'] as String?
    ..updatedAt = json['updated_at'] as String?
    ..lastReadAt = json['last_read_at'] as String?
    ..subject = json['subject'] == null
        ? null
        : NotificationSubject.fromJson(json['subject'] as Map<String, dynamic>)
    ..repository = json['repository'] == null
        ? null
        : Repository.fromJson(json['repository'] as Map<String, dynamic>)
    ..url = json['url'] as String?
    ..subscriptionUrl = json['subscription_url'] as String?;
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unread': instance.unread,
      'reason': instance.reason,
      'updated_at': instance.updatedAt,
      'last_read_at': instance.lastReadAt,
      'subject': instance.subject,
      'repository': instance.repository,
      'url': instance.url,
      'subscription_url': instance.subscriptionUrl,
    };
