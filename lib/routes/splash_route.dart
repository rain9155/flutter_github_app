import 'package:flutter/material.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/models/user_model.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/routes/login_route.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:provider/provider.dart';

import 'home_route.dart';

class SplashRoute extends StatelessWidget{

  static const name = 'splashRoute';

  @override
  Widget build(BuildContext context) {
    var userModel = Provider.of<UserModel>(context, listen: false);
    userModel.isLogin().then((isLogin){
      Future.delayed(Duration(seconds: 3), () async{
        if(isLogin){
          String token = await userModel.getToken();
          debugPrint('token = $token');
          Navigator.of(context).pushReplacementNamed(HomeRoute.name);
        }else{
          Navigator.of(context).pushReplacementNamed(LoginRoute.name);
        }
      });
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