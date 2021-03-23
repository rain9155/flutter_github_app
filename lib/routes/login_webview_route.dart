
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/device_code.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_appbar.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:webview_flutter/webview_flutter.dart';


class LoginWebViewRoute extends StatefulWidget{

  static final name = 'loginWebViewRoute';
  static final tag = 'LoginWebViewRoute';

  static route(){
    return LoginWebViewRoute();
  }

  static Future push(BuildContext context, {
    @required DeviceCode deviceCode,
  }){
    return Navigator.of(context).pushNamed(LoginWebViewRoute.name, arguments: deviceCode);
  }

  @override
  State createState() {
    return _LoginWebViewRouteState();
  }
}

class _LoginWebViewRouteState extends State<LoginWebViewRoute>{

  final Completer<WebViewController> _completer = Completer<WebViewController>();
  bool _isDeviceVerified = false;
  bool _isLoading = false;
  bool _isDeviceVerifyLoadError = false;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceCode deviceCode = ModalRoute.of(context).settings.arguments as DeviceCode;
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
            title: CommonTitle(
              AppLocalizations.of(context).deviceAuth,
            ),
            onBack: () async{
              Navigator.of(context).pop(false);
              return false;
            },
            actions: [
              CommonAction(
                icon: Icons.refresh,
                tooltip: AppLocalizations.of(context).refresh,
                onPressed: _completer.isCompleted ? () async{
                  (await _completer.future).reload();
                  setState(() {
                    _isLoading = true;
                    _isDeviceVerifyLoadError = false;
                  });
                } : null,
              )
            ]
        );
      },
      body: _buildBody(deviceCode),
    );

  }

  Widget _buildBody(DeviceCode deviceCode) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop(false);
        return false;
      },
      child: Stack(
        children: [
          WebView(
            initialUrl: deviceCode.verificationUri,
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (controller){
              LogUtil.printString(LoginWebViewRoute.tag, 'onWebViewCreated');
              _completer.complete(controller);
              setState(() {
                _isLoading = true;
              });
            },
            onWebResourceError: (error){
              LogUtil.printString(LoginWebViewRoute.tag, 'onWebResourceError: code = ${error.errorCode}, des = ${error.description}, url = ${error.failingUrl}');
              if(error.failingUrl == deviceCode.verificationUri){
                _isDeviceVerifyLoadError = true;
              }
            },
            navigationDelegate: (navigate){
              LogUtil.printString(LoginWebViewRoute.tag, 'navigationDelegate: url = ${navigate.url}');
              if(navigate.url.contains('login/device/failure')){
                Navigator.pop(context, false);
              }
              if(navigate.url.contains('login/device/success')){
                Navigator.pop(context, true);
              }
              if(navigate.url.contains('dashboard')){
                Navigator.pop(context, false);
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url){
              LogUtil.printString(LoginWebViewRoute.tag, 'onPageStarted: url = $url');
            },
            onPageFinished: (url){
              LogUtil.printString(LoginWebViewRoute.tag, 'onPageFinished: url = $url');
              if(url == deviceCode.verificationUri){
                if(!_isDeviceVerified && !_isDeviceVerifyLoadError){
                  setState(() {
                    _isDeviceVerified = true;
                  });
                }
              }else{
                if(_isDeviceVerified){
                  setState(() {
                    _isDeviceVerified = false;
                  });
                }
              }
              if(_isLoading){
                setState(() {
                  _isLoading = false;
                });
              }
            }
          ),
          if(_isDeviceVerified)
            Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Text(
                  'Enter "${deviceCode.userCode}" in the box below',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      color: Theme.of(context).errorColor
                  ),
                )
            ),
          if(_isLoading)
            LinearProgressIndicator()
        ],
      ),
    );
  }

}