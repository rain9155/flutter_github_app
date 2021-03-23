import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRoute extends StatefulWidget{

  static final name = 'webViewRoute';
  static final tag = 'WebViewRoute';

  static route(){
    return WebViewRoute();
  }

  static Future push(BuildContext context, {
    @required String url,
    String title,
  }){
    return Navigator.of(context).pushNamed(WebViewRoute.name, arguments: {
      KEY_URL: url,
      KEY_TITLE: title
    });
  }

  @override
  State createState() {
    return _WebViewRouteState();
  }
}

class _WebViewRouteState extends State<WebViewRoute>{

  bool _isLoading = false;
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments as Map;
    String title = arguments[KEY_TITLE];
    String url = arguments[KEY_URL];
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
          title: CommonTitle(title?? url?? ''),
          actions: [
            CommonAction(
              icon: Icons.refresh,
              tooltip: AppLocalizations.of(context).refresh,
              onPressed: (){
                if(_controller == null || _isLoading){
                  ToastUtil.showSnackBar(context, AppLocalizations.of(context).loading);
                  return;
                }
                _controller.reload();
                setState(() {
                  _isLoading = true;
                });
              }
            )
          ],
          onBack: back,
        );
      },
      body: _buildBody(url),
    );
  }

  Widget _buildBody(String url) {
    return WillPopScope(
      onWillPop: () => back(),
      child: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (controller){
              LogUtil.printString(WebViewRoute.tag, 'onWebViewCreated');
              _controller = controller;
              setState(() {
                _isLoading = true;
              });
            },
            onPageStarted: (url){
              LogUtil.printString(WebViewRoute.tag, 'onPageStarted: url = $url');
              if(_isLoading){
                setState(() {
                  _isLoading = true;
                });
              }
            },
            onPageFinished: (url){
              LogUtil.printString(WebViewRoute.tag, 'onPageFinished: url = $url');
              if(_isLoading){
                setState(() {
                  _isLoading = false;
                });
              }
            }
          ),
          if(_isLoading) LinearProgressIndicator()
        ],
      ),
    );
  }

  Future<bool> back() async {
    if(_controller == null || ! await _controller.canGoBack()){
      return true;
    }
    _controller.goBack();
    return false;
  }

}