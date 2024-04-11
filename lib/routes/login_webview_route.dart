
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/device_code.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/linear_loading_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWebViewRoute extends StatelessWidget {

  static final name = 'LoginWebViewRoute';

  static route(){
    return LoginWebViewRoute._();
  }

  LoginWebViewRoute._();

  static Future push(BuildContext context, {
    required DeviceCode? deviceCode,
  }){
    return Navigator.of(context).pushNamed(LoginWebViewRoute.name, arguments: deviceCode);
  }
  
  @override
  Widget build(BuildContext context) {
    DeviceCode deviceCode = ModalRoute.of(context)!.settings.arguments as DeviceCode;
    return _LoginWebViewWidget(deviceCode);
  }
  
}

class _LoginWebViewWidget extends StatefulWidget {

  _LoginWebViewWidget(this.deviceCode);

  final DeviceCode deviceCode;

  @override
  State<StatefulWidget> createState() {
    return _LoginWebViewWidgetState();
  }

}

class _LoginWebViewWidgetState extends State<_LoginWebViewWidget>{

  bool _isDeviceVerifyLoaded = false;
  bool _isLoading = true;
  bool _isDeviceVerifyLoadError = false;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (error){
          LogUtil.printString(LoginWebViewRoute.name, 'onWebResourceError: code = ${error.errorCode}, des = ${error.description}, url = ${error.url}');
          if(error.url == widget.deviceCode.verificationUri){
            _isDeviceVerifyLoadError = true;
          }
        },
        onNavigationRequest: (navigate){
          LogUtil.printString(LoginWebViewRoute.name, 'navigationDelegate: url = ${navigate.url}');
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
          LogUtil.printString(LoginWebViewRoute.name, 'onPageStarted: url = $url');
        },
        onPageFinished: (url){
          LogUtil.printString(LoginWebViewRoute.name, 'onPageFinished: url = $url');
          if(url == widget.deviceCode.verificationUri){
            if(!_isDeviceVerifyLoaded && !_isDeviceVerifyLoadError){
              setState(() {
                _isDeviceVerifyLoaded = true;
              });
            }
          }else{
            if(_isDeviceVerifyLoaded){
              setState(() {
                _isDeviceVerifyLoaded = false;
              });
            }
          }
          if(_isLoading){
            setState(() {
              _isLoading = false;
            });
          }
        }
      )
    )
    ..loadRequest(Uri.parse(widget.deviceCode.verificationUri!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context) as PreferredSizeWidget?,
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar(BuildContext context){
    return CommonAppBar(
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
          onPressed: () {
            if(_isLoading) {
              return;
            }
            setState(() {
              _isLoading = true;
              _isDeviceVerifyLoadError = false;
            });
            _controller.reload();
          },
        )
      ]
    );
  }

  Widget _buildBody(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked:(didPop) {
        if(!didPop) {
          Navigator.of(context).pop(false);
        }
      },
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if(_isDeviceVerifyLoaded)
            Container(
                color: Theme.of(context).primaryColor,
                width: double.infinity,
                padding: EdgeInsets.all(12),
                child: Text(
                  'Enter "${widget.deviceCode.userCode}" in the box below',
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(1.2),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error
                  ),
                )
            ),
          if(_isLoading)
            LinearLoadingWidget()
        ],
      ),
    );
  }

}