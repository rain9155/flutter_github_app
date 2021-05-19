import 'package:json_annotation/json_annotation.dart';



part 'search.g.dart';

@JsonSerializable()
class Search {

  Search();

  @JsonKey(name: 'total_count')
  int? totalCount;
  @JsonKey(name: 'incomplete_results')
  bool? incompleteResults;
  @JsonKey(name: 'items')
  List<dynamic>? items;
  

  factory Search.fromJson(Map<String,dynamic> json) => _$SearchFromJson(json);

  Map<String, dynamic> toJson() => _$SearchToJson(this);

}