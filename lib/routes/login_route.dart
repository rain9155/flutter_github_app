import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/models/user_model.dart';
import 'package:flutter_github_app/net/api.dart';
import 'package:flutter_github_app/routes/webview_route.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/image_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatelessWidget{

  static const name = 'loginRoute';

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
              width: size.width - 20,
              child: RaisedButton(
                child: Text(AppLocalizations.of(context).login),
                onPressed: () => _login(context),
              ),
            )
          ],
        )
      ),
    );
  }

  _login(BuildContext context){
    DialogUtil.showLoading(context);
    Api.getInstance().getVerifyCode(
      onSuccess: (data) async{
        DialogUtil.dismissDialog(context);
        VerifyCode verifyCode = data;
        Navigator.of(context).pushNamed(
            WebViewRoute.name,
            arguments: verifyCode
        ).then((value){
          bool loginSuccess = value;
          if(!loginSuccess){
            ToastUtil.showToast(AppLocalizations.of(context).loginUnFinished);
          }else{
            _getAccessToken(context, verifyCode);
          }
        });
      },
      onError: (code, msg){
        DialogUtil.dismissDialog(context);
        ToastUtil.showToast('${AppLocalizations.of(context).loginFail}: $msg');
      }
    );
  }

  void _getAccessToken(BuildContext context, VerifyCode verifyCode) {
    DialogUtil.showLoading(context);
    Api.getInstance().getAccessToken(
      verifyCode.deviceCode,
      onSuccess: (token){
        DialogUtil.dismissDialog(context);
        UserModel userModel = Provider.of<UserModel>(context, listen: false);
        userModel.setToken(token);
      },
      onError: (code, msg){
        if(code == CODE_TOKEN_PENDING){
          Future.delayed(Duration(seconds: verifyCode.interval + 1), (){
            _getAccessToken(context, verifyCode);
          });
        }else{
          ToastUtil.showToast('${AppLocalizations.of(context).loginFail}: $msg');
        }
      }
    );
  }
  
}