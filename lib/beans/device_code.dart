import 'package:json_annotation/json_annotation.dart';



part 'device_code.g.dart';

@JsonSerializable()
class DeviceCode {

  DeviceCode();

  @JsonKey(name: 'device_code')
  String? deviceCode;
  @JsonKey(name: 'user_code')
  String? userCode;
  @JsonKey(name: 'verification_uri')
  String? verificationUri;
  @JsonKey(name: 'expires_in')
  int? expiresIn;
  @JsonKey(name: 'interval')
  int? interval;
  

  factory DeviceCode.fromJson(Map<String,dynamic> json) => _$DeviceCodeFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCodeToJson(this);

}