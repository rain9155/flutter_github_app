// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

License _$LicenseFromJson(Map<String, dynamic> json) {
  return License()
    ..key = json['key'] as String
    ..name = json['name'] as String
    ..spdxId = json['spdx_id'] as String
    ..url = json['url'] as String
    ..nodeId = json['node_id'] as String
    ..htmlUrl = json['html_url'] as String
    ..description = json['description'] as String
    ..implementation = json['implementation'] as String
    ..permissions = json['permissions'] as List
    ..conditions = json['conditions'] as List
    ..limitations = json['limitations'] as List
    ..body = json['body'] as String
    ..featured = json['featured'] as bool;
}

Map<String, dynamic> _$LicenseToJson(License instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'spdx_id': instance.spdxId,
      'url': instance.url,
      'node_id': instance.nodeId,
      'html_url': instance.htmlUrl,
      'description': instance.description,
      'implementation': instance.implementation,
      'permissions': instance.permissions,
      'conditions': instance.conditions,
      'limitations': instance.limitations,
      'body': instance.body,
      'featured': instance.featured,
    };
