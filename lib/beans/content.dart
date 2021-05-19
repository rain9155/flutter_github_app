import 'package:json_annotation/json_annotation.dart';



part 'content.g.dart';

@JsonSerializable()
class Content {

  Content();

  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'encoding')
  String? encoding;
  @JsonKey(name: 'size')
  int? size;
  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'path')
  String? path;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'sha')
  String? sha;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'git_url')
  String? gitUrl;
  @JsonKey(name: 'html_url')
  String? htmlUrl;
  @JsonKey(name: 'download_url')
  String? downloadUrl;
  

  factory Content.fromJson(Map<String,dynamic> json) => _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);

}