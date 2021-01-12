
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

const TAG = 'WebViewRoute';

class WebViewRoute extends StatefulWidget{

  static const name = 'webViewRoute';

  static route(){
    return WebViewRoute();
  }

  @override
  State createState() {
    return _WebViewRouteState();
  }
}

class _WebViewRouteState extends State<WebViewRoute>{

  final Completer<WebViewController> _completer = Completer<WebViewController>();
  bool _isDeviceVerified = false;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    VerifyCode verifyCode = ModalRoute.of(context).settings.arguments as VerifyCode;
    return Scaffold(
      appBar: AppBar(
        leading: _buildLeading(),
        title: _buildTitle(verifyCode),
        titleSpacing: 0.0,
        actions: [
          _buildReloadAction()
        ],
      ),
      body: _buildBody(verifyCode),
    );
  }

  Widget _buildLeading(){
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      onPressed: () => Navigator.of(context).pop(false)
    );
  }

  Widget _buildTitle(VerifyCode verifyCode) {
    return Text(
      verifyCode.verificationUri,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildReloadAction(){
    return FutureBuilder(
      future: _completer.future,
      builder: (context, snapshot){
        bool isWebViewReady = snapshot.connectionState == ConnectionState.done;
        return IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: !isWebViewReady
              ? null
              : (){
              DialogUtil.showLoading(context);
              (snapshot.data as WebViewController).reload();
            }
        );
      },
    );
  }

  Widget _buildBody(VerifyCode verifyCode) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop(false);
        return false;
      },
      child: Stack(
        children: [
          WebView(
            initialUrl: verifyCode.verificationUri,
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (controller){
              LogUtil.printString(TAG, 'onWebViewCreated');
              DialogUtil.showLoading(context);
              _completer.complete(controller);
            },
            navigationDelegate: (navigate){
              LogUtil.printString(TAG, 'navigationDelegate: url = ${navigate.url}');
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
            onPageFinished: (url){
              LogUtil.printString(TAG, 'onPageFinished: url = $url');
              DialogUtil.dismissDialog(context);
              if(url == verifyCode.verificationUri){
                if(!_isDeviceVerified){
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
            },
          ),
          Builder(
            builder: (context){
              if(_isDeviceVerified){
                return Container(
                  color: Theme.of(context).colorScheme.primary,
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Enter "${verifyCode.userCode}" in the box below',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error
                    ),
                  )
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

}