import 'package:json_annotation/json_annotation.dart';



part 'access_token.g.dart';

@JsonSerializable()
class AccessToken {

  AccessToken();

  @JsonKey(name: 'access_token')
  String accessToken;
  @JsonKey(name: 'token_type')
  String tokenType;
  @JsonKey(name: 'scope')
  String scope;
  @JsonKey(name: 'error')
  String error;
  @JsonKey(name: 'error_description')
  String errorDescription;
  

  factory AccessToken.fromJson(Map<String,dynamic> json) => _$AccessTokenFromJson(json);

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);

}