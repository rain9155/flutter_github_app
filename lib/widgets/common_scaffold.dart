import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';
import 'package:flutter_github_app/widgets/pull_refresh_widget.dart';

class CommonScaffold extends StatelessWidget{

  const CommonScaffold({
    required this.body,
    this.sliverHeaderBuilder,
    this.sliverHeadersBuilder,
    this.onRefresh,
    this.includeScaffold = true,
    this.hasAppBar = true,
    this.includeSafeArea = true,
    this.backgroundColor
  });

  final Widget body;

  final NestedScrollViewHeaderSliverBuilder? sliverHeaderBuilder;

  final NestedScrollViewHeaderSliversBuilder? sliverHeadersBuilder;

  final RefreshCallback? onRefresh;

  final bool includeScaffold;

  final bool hasAppBar;

  final bool includeSafeArea;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget child = NestedScrollView(
      physics: onRefresh != null ? AlwaysScrollableScrollPhysics() : null,
      headerSliverBuilder: sliverHeadersBuilder?? (context, innerBoxIsScrolled){
        return sliverHeaderBuilder == null ? [] : [
          sliverHeaderBuilder!.call(context, innerBoxIsScrolled)
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
    if(includeScaffold || backgroundColor != null){
      child = Scaffold(
        backgroundColor: backgroundColor,
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