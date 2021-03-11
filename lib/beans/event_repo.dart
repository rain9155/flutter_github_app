import 'package:json_annotation/json_annotation.dart';



part 'event_repo.g.dart';

@JsonSerializable()
class EventRepo {

  EventRepo();

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'url')
  String url;
  

  factory EventRepo.fromJson(Map<String,dynamic> json) => _$EventRepoFromJson(json);

  Map<String, dynamic> toJson() => _$EventRepoToJson(this);

}