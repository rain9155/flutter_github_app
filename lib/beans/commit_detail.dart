import 'package:json_annotation/json_annotation.dart';

import "commit_owner.dart";

part 'commit_detail.g.dart';

@JsonSerializable()
class CommitDetail {

  CommitDetail();

  @JsonKey(name: 'author')
  CommitOwner? author;
  @JsonKey(name: 'committer')
  CommitOwner? committer;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'tree')
  Map<String,dynamic>? tree;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'comment_count')
  int? commentCount;
  @JsonKey(name: 'verification')
  Map<String,dynamic>? verification;
  

  factory CommitDetail.fromJson(Map<String,dynamic> json) => _$CommitDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CommitDetailToJson(this);

}