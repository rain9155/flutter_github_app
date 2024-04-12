// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event()
  ..id = json['id'] as String?
  ..type = json['type'] as String?
  ..actor = json['actor'] == null
      ? null
      : EventActor.fromJson(json['actor'] as Map<String, dynamic>)
  ..repo = json['repo'] == null
      ? null
      : EventRepo.fromJson(json['repo'] as Map<String, dynamic>)
  ..payload = json['payload'] as Map<String, dynamic>?
  ..public = json['public'] as bool?
  ..createdAt = json['created_at'] as String?;

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'actor': instance.actor,
      'repo': instance.repo,
      'payload': instance.payload,
      'public': instance.public,
      'created_at': instance.createdAt,
    };
