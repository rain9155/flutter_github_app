import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_github_app/blocs/authentication_bloc.dart';
import 'package:flutter_github_app/blocs/login_bloc.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/loading_widget.dart';

class LoginRoute extends StatelessWidget{

  static final name = 'LoginRoute';

  static route(){
    return BlocProvider(
      create: (context) => LoginBloc(context, BlocProvider.of<AuthenticationBloc>(context)),
      child: LoginRoute._(),
    );
  }

  LoginRoute._();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              PATH_BRAND_IMG,
              width: 100,
              height: 100,
              color: Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? Colors.white
                : Colors.black,
            ),
            SizedBox(height: 30),
            Container(
              width: size.width - 30,
              height: 40,
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state){
                  Widget child;
                  if(state is LoginLoadingState){
                    child = SizedBox(
                        height: 25,
                        width: 25,
                        child: LoadingWidget(isScroll: false)
                    );
                  }else if(state is LoginFailureState){
                    ToastUtil.showToast(CommonUtil.getErrorMsgByCode(context, state.errorCode));
                    child = Text(AppLocalizations.of(context).clickTryAgain);
                  }else{
                    child = Text(AppLocalizations.of(context).login);
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))
                    ),
                    child: child,
                    onPressed: state is LoginLoadingState
                      ? null
                      : () => context.read<LoginBloc>().add(LoginButtonPressedEvent()),
                  );
                },
              ),
            )
          ],
        )
      )
    );
  }

}