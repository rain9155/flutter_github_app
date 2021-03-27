// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) {
  return Search()
    ..totalCount = json['total_count'] as int
    ..incompleteResults = json['incomplete_results'] as bool
    ..items = json['items'] as List;
}

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'total_count': instance.totalCount,
      'incomplete_results': instance.incompleteResults,
      'items': instance.items,
    };
