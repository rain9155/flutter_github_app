
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/profile_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/cubits/user_cubit.dart';
import 'package:flutter_github_app/routes/pages/profile_page.dart';

class ProfileRoute extends StatelessWidget{

  static const name = 'profileRoute';

  static route(){
    return ProfileRoute();
  }

  static Future push(BuildContext context, {
    String name,
    int routeType
  }){
    return Navigator.of(context).pushNamed(ProfileRoute.name, arguments: {
      KEY_NAME: name,
      KEY_ROUTE_TYPE: routeType
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePage.page()
    );
  }
}