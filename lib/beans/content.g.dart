// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content()
  ..type = json['type'] as String?
  ..encoding = json['encoding'] as String?
  ..size = json['size'] as int?
  ..name = json['name'] as String?
  ..path = json['path'] as String?
  ..content = json['content'] as String?
  ..sha = json['sha'] as String?
  ..url = json['url'] as String?
  ..gitUrl = json['git_url'] as String?
  ..htmlUrl = json['html_url'] as String?
  ..downloadUrl = json['download_url'] as String?;

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'type': instance.type,
      'encoding': instance.encoding,
      'size': instance.size,
      'name': instance.name,
      'path': instance.path,
      'content': instance.content,
      'sha': instance.sha,
      'url': instance.url,
      'git_url': instance.gitUrl,
      'html_url': instance.htmlUrl,
      'download_url': instance.downloadUrl,
    };
