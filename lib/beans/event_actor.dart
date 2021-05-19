import 'package:json_annotation/json_annotation.dart';



part 'event_actor.g.dart';

@JsonSerializable()
class EventActor {

  EventActor();

  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'login')
  String? login;
  @JsonKey(name: 'display_login')
  String? displayLogin;
  @JsonKey(name: 'gravatar_id')
  String? gravatarId;
  @JsonKey(name: 'url')
  String? url;
  @JsonKey(name: 'avatar_url')
  String? avatarUrl;
  

  factory EventActor.fromJson(Map<String,dynamic> json) => _$EventActorFromJson(json);

  Map<String, dynamic> toJson() => _$EventActorToJson(this);

}