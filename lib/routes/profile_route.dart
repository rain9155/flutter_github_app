
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/routes/pages/profile_page.dart';

class ProfileRoute extends StatelessWidget{

  static final name = 'ProfileRoute';

  static route(){
    return ProfileRoute._();
  }

  ProfileRoute._();

  static Future push(BuildContext context, {
    String? name,
    int routeType = ROUTE_TYPE_PROFILE_USER
  }){
    return Navigator.of(context).pushNamed(ProfileRoute.name, arguments: {
      KEY_NAME: name,
      KEY_ROUTE_TYPE: routeType
    });
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    int? routeType = arguments[KEY_ROUTE_TYPE];
    return Scaffold(
      body: ProfilePage.page(routeType == ROUTE_TYPE_PROFILE_ORG ? PAGE_TYPE_PROFILE_ORG : PAGE_TYPE_PROFILE_USER)
    );
  }
}