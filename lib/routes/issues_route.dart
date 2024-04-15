
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/pages/issues_page.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/primary_scroll_controller_hook.dart';

class IssuesRoute extends StatefulWidget{

  static final name = 'IssuesRoute';

  static route(){
    return IssuesRoute._();
  }

  IssuesRoute._();

  static Future push(BuildContext context, {
    String? name,
    String? repoName,
    int routeType = ROUTE_TYPE_ISSUES_USER
  }){
    return Navigator.of(context).pushNamed(IssuesRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName,
      KEY_ROUTE_TYPE: routeType
    });
  }

  @override
  _IssuesRouteState createState() => _IssuesRouteState();
}

class _IssuesRouteState extends State<IssuesRoute> with SingleTickerProviderStateMixin{

  late List<String> _titles;
  late List<GlobalObjectKey<PrimaryScrollControllerHookState>> _pageKeys;
  TabController? _controller;
  late VoidCallback _onTapChanged;

  @override
  void initState() {
    super.initState();
    _onTapChanged = (){
      for(int i = 0; i < _pageKeys.length; i++){
        _pageKeys[i].currentState?.onVisibleChanged(_controller!.index == i);
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context)!.settings.arguments as Map;
    int? routeType = arguments[KEY_ROUTE_TYPE];
    if(routeType == ROUTE_TYPE_ISSUES_REPO){
      _titles = [
        AppLocalizations.of(context).open.toUpperCase(),
        AppLocalizations.of(context).closed.toUpperCase(),
      ];
      _pageKeys = [
        GlobalObjectKey(PAGE_TYPE_ISSUES_OPEN),
        GlobalObjectKey(PAGE_TYPE_ISSUES_CLOSED)
      ];
    }else{
      _titles = [
        AppLocalizations.of(context).created.toUpperCase(),
        AppLocalizations.of(context).assigned.toUpperCase(),
        AppLocalizations.of(context).mentioned.toUpperCase(),
      ];
      _pageKeys = [
        GlobalObjectKey(PAGE_TYPE_ISSUES_CREATED),
        GlobalObjectKey(PAGE_TYPE_ISSUES_ASSIGNED),
        GlobalObjectKey(PAGE_TYPE_ISSUES_MENTIONED),
      ];
    }
    _controller?.removeListener(_onTapChanged);
    _controller = TabController(length: _titles.length, vsync: this);
    _controller!.addListener(_onTapChanged);
  }

  @override
  Widget build(BuildContext context) {
      return CommonScaffold(
        sliverHeaderBuilder: (context, _){
          return CommonSliverAppBar(
            title: CommonTitle(AppLocalizations.of(context).issues),
            bottom: TabBar(
              controller: _controller,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: _titles.map((title) => Tab(text: title)).toList()
            ),
          );
        },
        body: TabBarView(
          controller: _controller,
          children: _pageKeys.map<Widget>((key){
            return PrimaryScrollControllerHook(
              key: key,
              child: IssuesPage.page(key.value as int),
            );
          }).toList(),
        )
      );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}