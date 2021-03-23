import 'package:json_annotation/json_annotation.dart';

import "owner.dart";

part 'milestone.g.dart';

@JsonSerializable()
class Milestone {

  Milestone();

  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'labels_url')
  String labelsUrl;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'number')
  int number;
  @JsonKey(name: 'state')
  String state;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'creator')
  Owner creator;
  @JsonKey(name: 'open_issues')
  int openIssues;
  @JsonKey(name: 'closed_issues')
  int closedIssues;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'closed_at')
  String closedAt;
  @JsonKey(name: 'due_on')
  String dueOn;
  

  factory Milestone.fromJson(Map<String,dynamic> json) => _$MilestoneFromJson(json);

  Map<String, dynamic> toJson() => _$MilestoneToJson(this);

}