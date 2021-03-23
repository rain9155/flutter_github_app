// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Commit _$CommitFromJson(Map<String, dynamic> json) {
  return Commit()
    ..sha = json['sha'] as String
    ..nodeId = json['node_id'] as String
    ..commit = json['commit'] == null
        ? null
        : CommitDetail.fromJson(json['commit'] as Map<String, dynamic>)
    ..url = json['url'] as String
    ..htmlUrl = json['html_url'] as String
    ..commentsUrl = json['comments_url'] as String
    ..author = json['author'] == null
        ? null
        : Owner.fromJson(json['author'] as Map<String, dynamic>)
    ..committer = json['committer'] == null
        ? null
        : Owner.fromJson(json['committer'] as Map<String, dynamic>)
    ..parents = json['parents'] as List
    ..stats = json['stats'] as Map<String, dynamic>
    ..files = json['files'] as Map<String, dynamic>;
}

Map<String, dynamic> _$CommitToJson(Commit instance) => <String, dynamic>{
      'sha': instance.sha,
      'node_id': instance.nodeId,
      'commit': instance.commit,
      'url': instance.url,
      'html_url': instance.htmlUrl,
      'comments_url': instance.commentsUrl,
      'author': instance.author,
      'committer': instance.committer,
      'parents': instance.parents,
      'stats': instance.stats,
      'files': instance.files,
    };
