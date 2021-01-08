// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyCode _$VerifyCodeFromJson(Map<String, dynamic> json) {
  return VerifyCode()
    ..deviceCode = json['device_code'] as String
    ..userCode = json['user_code'] as String
    ..verificationUri = json['verification_uri'] as String
    ..expiresIn = json['expires_in'] as int
    ..interval = json['interval'] as int;
}

Map<String, dynamic> _$VerifyCodeToJson(VerifyCode instance) =>
    <String, dynamic>{
      'device_code': instance.deviceCode,
      'user_code': instance.userCode,
      'verification_uri': instance.verificationUri,
      'expires_in': instance.expiresIn,
      'interval': instance.interval,
    };
