import 'package:json_annotation/json_annotation.dart';



part 'notification_subject.g.dart';

@JsonSerializable()
class NotificationSubject {

  NotificationSubject();

  @JsonKey(name: 'title')
  String title;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'latest_comment_url')
  String latestCommentUrl;
  @JsonKey(name: 'type')
  String type;
  

  factory NotificationSubject.fromJson(Map<String,dynamic> json) => _$NotificationSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSubjectToJson(this);

}