// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) => AccessToken()
  ..accessToken = json['access_token'] as String?
  ..tokenType = json['token_type'] as String?
  ..scope = json['scope'] as String?
  ..error = json['error'] as String?
  ..errorDescription = json['error_description'] as String?;

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'error': instance.error,
      'error_description': instance.errorDescription,
    };
