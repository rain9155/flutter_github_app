// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_repo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRepo _$EventRepoFromJson(Map<String, dynamic> json) {
  return EventRepo()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..url = json['url'] as String;
}

Map<String, dynamic> _$EventRepoToJson(EventRepo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
    };
