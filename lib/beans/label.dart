import 'package:json_annotation/json_annotation.dart';



part 'label.g.dart';

@JsonSerializable()
class Label {

  Label();

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'description')
  String description;
  @JsonKey(name: 'color')
  String color;
  

  factory Label.fromJson(Map<String,dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);

}