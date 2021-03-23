import 'package:json_annotation/json_annotation.dart';



part 'license.g.dart';

@JsonSerializable()
class License {

  License();

  @JsonKey(name: 'key')
  String key;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'spdx_id')
  String spdxId;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'implementation')
  String implementation;
  @JsonKey(name: 'permissions')
  List<dynamic> permissions;
  @JsonKey(name: 'conditions')
  List<dynamic> conditions;
  @JsonKey(name: 'limitations')
  List<dynamic> limitations;
  @JsonKey(name: 'body')
  String body;
  @JsonKey(name: 'featured')
  bool featured;
  

  factory License.fromJson(Map<String,dynamic> json) => _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);

}