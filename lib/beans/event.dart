import 'package:json_annotation/json_annotation.dart';

import "event_actor.dart";
import "event_repo.dart";

part 'event.g.dart';

@JsonSerializable()
class Event {

  Event();

  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'type')
  String? type;
  @JsonKey(name: 'actor')
  EventActor? actor;
  @JsonKey(name: 'repo')
  EventRepo? repo;
  @JsonKey(name: 'payload')
  Map<String,dynamic>? payload;
  @JsonKey(name: 'public')
  bool? public;
  @JsonKey(name: 'created_at')
  String? createdAt;
  

  factory Event.fromJson(Map<String,dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

}