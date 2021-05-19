
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/utils/common_util.dart';

/// github官方api，参考：
/// https://docs.github.com/en/rest/reference
class Url{

  Url._internal();

  static String deviceCodeUrl(){
    return _baseUrlAppendWith('/login/device/code');
  }

  static String accessTokenUrl(){
    return _baseUrlAppendWith('/login/oauth/access_token');
  }

  static String notificationsUrl(){
    return _baseApiUrlAppendWith('/notifications');
  }


  static String issuesUrl(){
    return _baseApiUrlAppendWith('/issues');
  }

  static String receivedEventsUrl(String? userName){
    return _baseApiUrlAppendWith("/users/$userName/received_events");
  }

  static String userEvents(String? userName){
    return _baseApiUrlAppendWith('/users/$userName/events');
  }

  static String userUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user');
    }
    return _baseApiUrlAppendWith('/users/$userName');
  }

  static String repositoriesUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/repos');
    }
    return _baseApiUrlAppendWith('/users/$userName/repos');
  }

  static String watchingRepositoriesUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/subscriptions');
    }
    return _baseApiUrlAppendWith('/users/$userName/subscriptions');
  }

  static String starredRepositoriesUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/starred');
    }
    return _baseApiUrlAppendWith('/users/$userName/starred');
  }

  static String followersUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/followers');
    }
    return _baseApiUrlAppendWith('/users/$userName/followers');
  }

  static String followingUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/following');
    }
    return _baseApiUrlAppendWith('/users/$userName/following');
  }

  static String organizationsUrl(String? userName){
    if(CommonUtil.isTextEmpty(userName)){
      return _baseApiUrlAppendWith('/user/orgs');
    }
    return _baseApiUrlAppendWith('/users/$userName/orgs');
  }

  static String checkUserStarRepoUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/user/starred/$name/$repoName');
  }

  static String checkUserFollowUserUrl(String? userName){
    return _baseApiUrlAppendWith('/user/following/$userName');
  }

  static String organizationUrl(String? name){
    return _baseApiUrlAppendWith('/orgs/$name');
  }

  static String orgRepositoriesUrl(String? name){
    return _baseApiUrlAppendWith('/orgs/$name/repos');
  }

  static String orgMembersUrl(String? name){
    return _baseApiUrlAppendWith('/orgs/$name/members');
  }

  static String repositoryUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName');
  }

  static String readmeUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/readme');
  }

  static String stargazersUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/stargazers');
  }

  static String forksUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/forks');
  }

  static String branchesUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/branches');
  }

  static String watchersUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/subscribers');
  }

  static String commitsUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/commits');
  }

  static String contentsUrl(String? name, String? repoName, String? path){
    if(CommonUtil.isTextEmpty(path)){
      return _baseApiUrlAppendWith('/repos/$name/$repoName/contents');
    }
    return _baseApiUrlAppendWith('/repos/$name/$repoName/contents/$path');
  }

  static String repoIssuesUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/issues');
  }

  static String repoPullsUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/pulls');
  }

  static String createIssueUrl(String? name, String? repoName){
    return _baseApiUrlAppendWith('/repos/$name/$repoName/issues');
  }

  static String searchIssuesUrl(){
    return _baseApiUrlAppendWith('/search/issues');
  }

  static String searchReposUrl(){
    return _baseApiUrlAppendWith('/search/repositories');
  }

  static String searchUsersUrl(){
    return _baseApiUrlAppendWith('/search/users');
  }

  static String licenseUrl(String? key){
    return _baseApiUrlAppendWith('/licenses/$key');
  }

  static String _baseApiUrlAppendWith(String relativePath){
    return '$URL_BASE_API$relativePath';
  }

  static String _baseUrlAppendWith(String relativePath){
    return '$URL_BASE$relativePath';
  }

}