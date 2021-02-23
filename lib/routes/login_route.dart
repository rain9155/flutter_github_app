import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/blocs/login_bloc.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatelessWidget{

  static const name = 'loginRoute';

  static route(){
    return BlocProvider(
      create: (context) => LoginBloc(context, BlocProvider.of<AuthenticationBloc>(context)),
      child: LoginRoute(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageUtil.getBrandAssetsPath(),
              width: 100,
              height: 100,
            ),
            Container(
              width: size.width - 30,
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state){
                  Widget child;
                  if(state is LoginLoadingState){
                    child = SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator()
                    );
                  }else{
                    child = Text(AppLocalizations.of(context).login);
                  }
                  if(state is LoginFailureState){
                    ToastUtil.showToast(state.error);
                  }
                  return SizedBox(
                    height: 40,
                    child: RaisedButton(
                      onPressed: state is LoginLoadingState
                          ? null
                          : () => context.read<LoginBloc>().add(LoginButtonPressedEvent()),
                      child: child
                    ),
                  );
                },
              ),
            )
          ],
        )
      ),
    );
  }

}