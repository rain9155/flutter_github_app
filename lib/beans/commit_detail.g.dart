// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommitDetail _$CommitDetailFromJson(Map<String, dynamic> json) {
  return CommitDetail()
    ..author = json['author'] == null
        ? null
        : CommitOwner.fromJson(json['author'] as Map<String, dynamic>)
    ..committer = json['committer'] == null
        ? null
        : CommitOwner.fromJson(json['committer'] as Map<String, dynamic>)
    ..message = json['message'] as String?
    ..tree = json['tree'] as Map<String, dynamic>?
    ..url = json['url'] as String?
    ..commentCount = json['comment_count'] as int?
    ..verification = json['verification'] as Map<String, dynamic>?;
}

Map<String, dynamic> _$CommitDetailToJson(CommitDetail instance) =>
    <String, dynamic>{
      'author': instance.author,
      'committer': instance.committer,
      'message': instance.message,
      'tree': instance.tree,
      'url': instance.url,
      'comment_count': instance.commentCount,
      'verification': instance.verification,
    };
