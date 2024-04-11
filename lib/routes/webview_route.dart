import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/utils/common_util.dart';
import 'package:flutter_github_app/utils/log_util.dart';
import 'package:flutter_github_app/utils/toast_util.dart';
import 'package:flutter_github_app/widgets/common_action.dart';
import 'package:flutter_github_app/widgets/common_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/linear_loading_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRoute extends StatelessWidget{

  static final name = 'WebViewRoute';

  static route(){
    return WebViewRoute._();
  }

  WebViewRoute._();

  static Future push(BuildContext context, {
    required String? url,
    String? title,
  }){
    return Navigator.of(context).pushNamed(WebViewRoute.name, arguments: {
      KEY_URL: url,
      KEY_TITLE: title
    });
  }

  static Future popAndPush(BuildContext context, {
    required String? url,
    String? title,
  }){
    return Navigator.of(context).popAndPushNamed(WebViewRoute.name, arguments: {
      KEY_URL: url,
      KEY_TITLE: title
    });
  }
  
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String? title = arguments[KEY_TITLE];
    String? url = arguments[KEY_URL];
    return _WebViewWidget(title ?? "", url ?? "");
  }
}


class _WebViewWidget extends StatefulWidget {

  _WebViewWidget(
    this.title,
    this.url
  );

  final String title;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return _WebViewWidgetState();
  }
}

class _WebViewWidgetState extends State<_WebViewWidget>{

  bool _isLoading = true;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (error){
          LogUtil.printString(WebViewRoute.name, 'onWebResourceError: code = ${error.errorCode}, des = ${error.description}, url = ${error.url}');
        },
        onPageStarted: (url){
          LogUtil.printString(WebViewRoute.name, 'onPageStarted: url = $url');
          if(!_isLoading){
            setState(() {
              _isLoading = true;
            });
          }
        },
        onPageFinished: (url){
          LogUtil.printString(WebViewRoute.name, 'onPageFinished: url = $url');
          if(_isLoading){
            setState(() {
              _isLoading = false;
            });
          }
        }
      )
    )
    ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context) as PreferredSizeWidget?,
      body: _buildBody(),
    );
  }

  

  Widget _buildAppBar(BuildContext context) {
    return CommonAppBar(
      title: CommonTitle(widget.title),
      actions: [
        CommonAction(
            icon: Icons.share_outlined,
            tooltip: AppLocalizations.of(context).share,
            onPressed: () => Share.share(widget.url)
        ),
        CommonAction(
            icon: Icons.open_in_browser_outlined,
            tooltip: AppLocalizations.of(context).browser,
            onPressed: () => launchUrl(Uri.parse(widget.url))
        ),
        CommonAction(
            icon: Icons.refresh,
            tooltip: AppLocalizations.of(context).refresh,
            onPressed: (){
              if(_isLoading){
                ToastUtil.showSnackBar(context, msg: AppLocalizations.of(context).loading);
                return;
              }
              setState(() {
                _isLoading = true;
              });
              _controller.reload();
            }
        )
      ],
      onBack: back,
    );
  }

  Widget _buildBody() {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if(!didPop) {
          back().then((value) {
            if(value) {
              Navigator.of(context).pop();
            }
          });
        }
      },
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if(_isLoading) 
            LinearLoadingWidget()
        ],
      ),
    );
  }

  Future<bool> back() async {
    if(CommonUtil.isTextEmpty(await _controller.currentUrl())) {
      return true;
    }

    if(!await _controller.canGoBack()){
      return true;
    }

    _controller.goBack();
    return false;
  }

}