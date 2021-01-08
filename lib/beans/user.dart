import 'package:json_annotation/json_annotation.dart';



part 'user.g.dart';

@JsonSerializable()
class User {

  User();

  @JsonKey(name: 'login')
  String login;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'node_id')
  String nodeId;
  @JsonKey(name: 'avatar_url')
  String avatarUrl;
  @JsonKey(name: 'gravatar_id')
  String gravatarId;
  @JsonKey(name: 'url')
  String url;
  @JsonKey(name: 'html_url')
  String htmlUrl;
  @JsonKey(name: 'followers_url')
  String followersUrl;
  @JsonKey(name: 'following_url')
  String followingUrl;
  @JsonKey(name: 'gists_url')
  String gistsUrl;
  @JsonKey(name: 'starred_url')
  String starredUrl;
  @JsonKey(name: 'subscriptions_url')
  String subscriptionsUrl;
  @JsonKey(name: 'organizations_url')
  String organizationsUrl;
  @JsonKey(name: 'repos_url')
  String reposUrl;
  @JsonKey(name: 'events_url')
  String eventsUrl;
  @JsonKey(name: 'received_events_url')
  String receivedEventsUrl;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'site_admin')
  bool siteAdmin;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'company')
  String company;
  @JsonKey(name: 'blog')
  String blog;
  @JsonKey(name: 'location')
  String location;
  @JsonKey(name: 'email')
  String email;
  @JsonKey(name: 'hireable')
  bool hireable;
  @JsonKey(name: 'bio')
  String bio;
  @JsonKey(name: 'twitter_username')
  String twitterUsername;
  @JsonKey(name: 'public_repos')
  int publicRepos;
  @JsonKey(name: 'public_gists')
  int publicGists;
  @JsonKey(name: 'followers')
  int followers;
  @JsonKey(name: 'following')
  int following;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  @JsonKey(name: 'private_gists')
  int privateGists;
  @JsonKey(name: 'total_private_repos')
  int totalPrivateRepos;
  @JsonKey(name: 'owned_private_repos')
  int ownedPrivateRepos;
  @JsonKey(name: 'disk_usage')
  int diskUsage;
  @JsonKey(name: 'collaborators')
  int collaborators;
  @JsonKey(name: 'two_factor_authentication')
  bool twoFactorAuthentication;
  @JsonKey(name: 'plan')
  Map<String,dynamic> plan;
  

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}