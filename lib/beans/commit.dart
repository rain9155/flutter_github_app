import 'package:json_annotation/json_annotation.dart';

import "commit_detail.dart";
import "owner.dart";

part 'commit.g.dart';

@JsonSerializable()
class Commit {

  Commit();

  @JsonKey(name: 'sha')
  String? sha;
  @JsonKey(name: 'node_id')
  String? nodeId;
  @JsonKey(name: 'commit')
  CommitDetail? commit;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'html_url')
  String? htmlUrl;
  @JsonKey(name: 'comments_url')
  String? commentsUrl;
  @JsonKey(name: 'author')
  Owner? author;
  @JsonKey(name: 'committer')
  Owner? committer;
  @JsonKey(name: 'parents')
  List<dynamic>? parents;
  @JsonKey(name: 'stats')
  Map<String,dynamic>? stats;
  @JsonKey(name: 'files')
  Map<String,dynamic>? files;
  

  factory Commit.fromJson(Map<String,dynamic> json) => _$CommitFromJson(json);

  Map<String, dynamic> toJson() => _$CommitToJson(this);

}