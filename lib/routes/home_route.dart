import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';

class HomeRoute extends StatelessWidget{

  static const name = 'homeRoute';

  static route(){
    return HomeRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('login out'),
          onPressed: (){
            final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
            authenticationBloc.add(LoggedOutEvent());
          },
        ),
      ),
    );
  }

}