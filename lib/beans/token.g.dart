// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token()
    ..id = json['id'] as int
    ..url = json['url'] as String
    ..scopes = json['scopes'] as List
    ..token = json['token'] as String
    ..tokenLastEight = json['token_last_eight'] as String
    ..hashedToken = json['hashed_token'] as String
    ..app = json['app'] as Map<String, dynamic>
    ..note = json['note'] as String
    ..noteUrl = json['note_url'] as String
    ..updatedAt = json['updated_at'] as String
    ..createdAt = json['created_at'] as String
    ..fingerprint = json['fingerprint'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'scopes': instance.scopes,
      'token': instance.token,
      'token_last_eight': instance.tokenLastEight,
      'hashed_token': instance.hashedToken,
      'app': instance.app,
      'note': instance.note,
      'note_url': instance.noteUrl,
      'updated_at': instance.updatedAt,
      'created_at': instance.createdAt,
      'fingerprint': instance.fingerprint,
      'user': instance.user,
    };
