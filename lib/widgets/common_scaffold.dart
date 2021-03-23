import 'package:flutter/material.dart';
import 'package:flutter_github_app/configs/callback.dart';
import 'package:flutter_github_app/widgets/custom_scroll_config.dart';

class CommonScaffold extends StatelessWidget{

  const CommonScaffold({
    this.sliverHeaderBuilder,
    this.sliverHeadersBuilder,
    this.body,
    this.onRefresh,
    this.includeScaffold = true,
    this.hasAppBar = true
  });

  final NestedScrollViewHeaderSliverBuilder sliverHeaderBuilder;

  final NestedScrollViewHeaderSliversBuilder sliverHeadersBuilder;

  final Widget body;

  final RefreshCallback onRefresh;

  final bool includeScaffold;

  final bool hasAppBar;

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
      double statusBarHeight = MediaQuery.of(context).padding.top;
      double appBarHeight = kToolbarHeight;
      child = RefreshIndicator(
          child: child,
          onRefresh: onRefresh,
          displacement: hasAppBar ? (40 + appBarHeight + statusBarHeight) : 40,
          notificationPredicate: (notification) => true,
      );
    }
    if(includeScaffold){
      child = Scaffold(
        body: child
      );
    }
    return CustomScrollConfiguration(child: child);
  }
}