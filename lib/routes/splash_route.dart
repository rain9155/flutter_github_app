import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:provider/provider.dart';

class SplashRoute extends StatefulWidget{

  static final name = 'SplashRoute';

  static route(){
    return SplashRoute._();
  }

  SplashRoute._();

  @override
  _SplashRouteState createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () => context.read<AuthenticationBloc>().add(AppStartedEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CommonUtil.setSystemUIColor(CommonUtil.isDarkMode(context));
    CommonUtil.setEnabledSystemUI(bottom: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          PATH_BRAND_IMG,
          width: 100,
          height: 100,
          color: Theme.of(context).backgroundColor.computeLuminance() < 0.5
              ? Colors.white
              : Colors.black,
          frameBuilder: (context, child, frame, _){
            if(frame == null){
              return Container();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                SizedBox(height: 15),
                Text(
                  AppLocalizations.of(context).appName,
                  style: Theme.of(context).textTheme.headline3
                )
              ],
            );
          },
        )
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    CommonUtil.setEnabledSystemUI(bottom: true);
  }
}
