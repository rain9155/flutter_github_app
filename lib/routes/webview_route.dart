
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/beans/verify_code.dart';
import 'package:flutter_github_app/utils/dialog_utIl.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebViewRoute extends StatefulWidget{

  static const name = 'webViewRoute';
  static const tag = 'WebViewRoute';

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
  bool _isLoading = false;

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
    return Builder(
      builder: (context){
        return IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.of(context).pop(false)
        );
      },
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
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: !isWebViewReady
                ? null
                : (){
              (snapshot.data as WebViewController).reload();
              setState(() {
                _isLoading = true;
              });
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
              LogUtil.printString(WebViewRoute.tag, 'onWebViewCreated');
              _completer.complete(controller);
              setState(() {
                _isLoading = true;
              });
            },
            navigationDelegate: (navigate){
              LogUtil.printString(WebViewRoute.tag, 'navigationDelegate: url = ${navigate.url}');
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
              LogUtil.printString(WebViewRoute.tag, 'onPageFinished: url = $url');
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
              if(_isLoading){
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
          Builder(
            builder: (context){
              if(_isDeviceVerified){
                return Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Enter "${verifyCode.userCode}" in the box below',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                    style: TextStyle(
                      color: Theme.of(context).errorColor
                    ),
                  )
                );
              }
              return Container();
            },
          ),
          Builder(
            builder: (context){
              if(_isLoading){
                return LinearProgressIndicator();
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

}