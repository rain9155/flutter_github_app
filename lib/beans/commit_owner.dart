import 'package:json_annotation/json_annotation.dart';



part 'commit_owner.g.dart';

@JsonSerializable()
class CommitOwner {

  CommitOwner();

  @JsonKey(name: 'name')
  String? name;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'date')
  String? date;
  

  factory CommitOwner.fromJson(Map<String,dynamic> json) => _$CommitOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$CommitOwnerToJson(this);

}