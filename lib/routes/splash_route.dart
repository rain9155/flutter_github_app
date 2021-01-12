import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:provider/provider.dart';

import 'home_route.dart';

class SplashRoute extends StatelessWidget{

  static const name = 'splashRoute';

  static route(){
    return SplashRoute();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), (){
      context.read<AuthenticationBloc>().add(AppStartedEvent());
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageUtil.getBrandAssetsPath()
            ),
            Text(
              AppLocalizations.of(context).appName,
              style: Theme.of(context).textTheme.headline3,
            )
          ],
        ),
      ),
    );
  }
}