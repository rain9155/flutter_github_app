import 'package:json_annotation/json_annotation.dart';

import "user.dart";

part 'token.g.dart';

@JsonSerializable()
class Token {

  Token();

  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'scopes')
  List<dynamic> scopes;
  @JsonKey(name: 'token')
  String token;
  @JsonKey(name: 'token_last_eight')
  String tokenLastEight;
  @JsonKey(name: 'hashed_token')
  String hashedToken;
  @JsonKey(name: 'app')
  Map<String,dynamic> app;
  @JsonKey(name: 'note')
  String note;
  @JsonKey(name: 'note_url')
  String noteUrl;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'fingerprint')
  String fingerprint;
  @JsonKey(name: 'user')
  User user;
  

  factory Token.fromJson(Map<String,dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

}