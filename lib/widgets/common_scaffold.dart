import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/pull_refresh_widget.dart';

class CommonScaffold extends StatelessWidget{

  const CommonScaffold({
    this.sliverHeaderBuilder,
    this.sliverHeadersBuilder,
    this.body,
    this.onRefresh,
    this.includeScaffold = true,
    this.hasAppBar = true,
    this.includeSafeArea = true
  });

  final NestedScrollViewHeaderSliverBuilder sliverHeaderBuilder;

  final NestedScrollViewHeaderSliversBuilder sliverHeadersBuilder;

  final Widget body;

  final RefreshCallback onRefresh;

  final bool includeScaffold;

  final bool hasAppBar;

  final bool includeSafeArea;

  @override
  Widget build(BuildContext context) {
    Widget child = NestedScrollView(
      physics: onRefresh != null ? AlwaysScrollableScrollPhysics() : null,
      headerSliverBuilder: sliverHeadersBuilder?? (context, innerBoxIsScrolled){
        return [
          sliverHeaderBuilder?.call(context, innerBoxIsScrolled)
        ];
      },
      body: body
    );
    if(onRefresh != null){
      child = PullRefreshWidget(
        child: child,
        onRefresh: onRefresh,
        displacementIncrease: hasAppBar,
        notificationPredicate: (notification) => true,
      );
    }
    if(includeScaffold){
      child = Scaffold(
        body: child
      );
    }
    if(includeSafeArea){
      child = SafeArea(
        top: false,
        bottom: false,
        child: child,
      );
    }
    return CustomScrollConfiguration(child: child);
  }
}