
import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/constant.dart';
import 'package:flutter_github_app/l10n/app_localizations.dart';
import 'package:flutter_github_app/routes/pages/pulls_page.dart';
import 'package:flutter_github_app/widgets/common_scaffold.dart';
import 'package:flutter_github_app/widgets/common_sliver_appbar.dart';
import 'package:flutter_github_app/widgets/common_title.dart';
import 'package:flutter_github_app/widgets/primary_scroll_controller_hook.dart';

class PullsRoute extends StatefulWidget{

  static final name = 'PullsRoute';

  static route(){
    return PullsRoute._();
  }

  static Future push(BuildContext context, {
    required String? name,
    required String? repoName,
  }){
    return Navigator.of(context).pushNamed(PullsRoute.name, arguments: {
      KEY_NAME: name,
      KEY_REPO_NAME: repoName
    });
  }

  PullsRoute._();

  @override
  _PullsRouteState createState() => _PullsRouteState();
}

class _PullsRouteState extends State<PullsRoute> with SingleTickerProviderStateMixin{

  late List<String> _titles;
  late List<GlobalObjectKey<PrimaryScrollControllerHookState>> _pageKeys;
  TabController? _controller;
  late VoidCallback _onTabChanged;

  @override
  void initState() {
    super.initState();
    _onTabChanged = (){
      for(int i = 0; i < _pageKeys.length; i++){
        _pageKeys[i].currentState?.onVisibleChanged(_controller!.index == i);
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _titles = [
      AppLocalizations.of(context).open,
      AppLocalizations.of(context).closed,
    ];
    _pageKeys = [
      GlobalObjectKey(PAGE_TYPE_PULLS_OPEN),
      GlobalObjectKey(PAGE_TYPE_PULLS_CLOSED)
    ];
    _controller?.removeListener(_onTabChanged);
    _controller = TabController(length: _titles.length, vsync: this);
    _controller!.addListener(_onTabChanged);

  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      sliverHeaderBuilder: (context, _){
        return CommonSliverAppBar(
          title: CommonTitle(AppLocalizations.of(context).pullRequests),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Theme.of(context).accentColor,
            tabs: _titles.map((title) => Tab(text: title)).toList()
          ),
        );
      },
      body: TabBarView(
        controller: _controller,
        children: _pageKeys.map<Widget>((key){
          return PrimaryScrollControllerHook(
            key: key,
            child: PullsPage.page(key.value as int)
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