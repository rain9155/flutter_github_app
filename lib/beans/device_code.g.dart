// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceCode _$DeviceCodeFromJson(Map<String, dynamic> json) {
  return DeviceCode()
    ..deviceCode = json['device_code'] as String
    ..userCode = json['user_code'] as String
    ..verificationUri = json['verification_uri'] as String
    ..expiresIn = json['expires_in'] as int
    ..interval = json['interval'] as int;
}

Map<String, dynamic> _$DeviceCodeToJson(DeviceCode instance) =>
    <String, dynamic>{
      'device_code': instance.deviceCode,
      'user_code': instance.userCode,
      'verification_uri': instance.verificationUri,
      'expires_in': instance.expiresIn,
      'interval': instance.interval,
    };
