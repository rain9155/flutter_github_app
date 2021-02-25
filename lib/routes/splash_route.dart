import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:provider/provider.dart';

class SplashRoute extends StatefulWidget{

  static const tag = 'SplashRoute';
  static const name = 'splashRoute';

  static route(){
    return SplashRoute();
  }

  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AuthenticationBloc>().add(AppStartedEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          ImageUtil.getBrandImgPath(),
          frameBuilder: (context, child, frame, _){
            if(frame == null){
              return Container();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                Text(
                  AppLocalizations.of(context).appName,
                  style: Theme.of(context).textTheme.headline3,
                )
              ],
            );
          },
        )
      )
    );
  }

}
