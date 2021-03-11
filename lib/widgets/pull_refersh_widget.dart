
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';

/// 下拉刷新组件
class PullRefreshWidget extends StatelessWidget{

  const PullRefreshWidget({
    this.refreshKey,
    @required this.child,
    @required this.onRefresh
  });

  final Key refreshKey;

  final Widget child;

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomScrollConfiguration(
      child: RefreshIndicator(
        key: refreshKey,
        child: child,
        onRefresh: onRefresh,
        displacement: 96,
      )
    );
  }

}