import 'package:json_annotation/json_annotation.dart';

import "notification_subject.dart";
import "notification_repo.dart";

part 'notification.g.dart';

@JsonSerializable()
class Notification {

  Notification();

  @JsonKey(name: 'id')
  String id;
  @JsonKey(name: 'unread')
  bool unread;
  @JsonKey(name: 'reason')
  String reason;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'last_read_at')
  String lastReadAt;
  @JsonKey(name: 'subject')
  NotificationSubject subject;
  @JsonKey(name: 'repository')
  NotificationRepo repository;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'subscription_url')
  String subscriptionUrl;
  

  factory Notification.fromJson(Map<String,dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

}