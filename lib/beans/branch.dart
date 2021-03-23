import 'package:json_annotation/json_annotation.dart';

import "commit.dart";

part 'branch.g.dart';

@JsonSerializable()
class Branch {

  Branch();

  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'commit')
  Commit commit;
  @JsonKey(name: 'protected')
  bool protected;
  

  factory Branch.fromJson(Map<String,dynamic> json) => _$BranchFromJson(json);

  Map<String, dynamic> toJson() => _$BranchToJson(this);

}