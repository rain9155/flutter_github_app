import 'package:json_annotation/json_annotation.dart';



part 'verify_code.g.dart';

@JsonSerializable()
class VerifyCode {

  VerifyCode();

  @JsonKey(name: 'device_code')
  String deviceCode;
  @JsonKey(name: 'user_code')
  String userCode;
  @JsonKey(name: 'verification_uri')
  String verificationUri;
  @JsonKey(name: 'expires_in')
  int expiresIn;
  @JsonKey(name: 'interval')
  int interval;
  

  factory VerifyCode.fromJson(Map<String,dynamic> json) => _$VerifyCodeFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeToJson(this);

}