// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Branch _$BranchFromJson(Map<String, dynamic> json) => Branch()
  ..name = json['name'] as String?
  ..commit = json['commit'] == null
      ? null
      : Commit.fromJson(json['commit'] as Map<String, dynamic>)
  ..protected = json['protected'] as bool?;

Map<String, dynamic> _$BranchToJson(Branch instance) => <String, dynamic>{
      'name': instance.name,
      'commit': instance.commit,
      'protected': instance.protected,
    };
